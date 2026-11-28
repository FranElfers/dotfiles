// Typing animation for Ghostty (VS Code-like):
//  - each new letter animates in where it was typed (LETTER_STYLE, BOUNCE)
//  - the previous letters of the line ripple a little (WAVE)
//  - the cursor glides to its new position with a fading trail (TRAIL)
//  - Enter sends a ring out from the cursor (RIPPLE)
//  - Backspace shakes the line (SHAKE)
// Every effect turns off by setting its strength/amount to 0.0.

// ---- Letter animation ------------------------------------------------------
//   0 = pop   (grows from small)
//   1 = fade  (fades in from the background)
//   2 = rise  (slides up from below)
//   3 = drop  (falls from above)
//   4 = glow  (starts in the cursor color, settles to normal)
const int   LETTER_STYLE    = 2;
const float LETTER_DURATION = 0.12;  // seconds
const float POP_START       = 0.55;  // initial scale for "pop"

// ---- Bounce: letters overshoot and spring back -----------------------------
const float BOUNCE          = 1.7;  // 0.0 = smooth stop, ~1.7 = clear bounce, 3.0 = springy

// ---- Wave: previous letters hop after each keystroke -----------------------
const float WAVE_HEIGHT     = 0.0;  // fraction of cell height (0.0 = off)
const float WAVE_CELLS      = 2.0;   // how many letters to the left it reaches
const float WAVE_DURATION   = 0.25;  // seconds
const float WAVE_DELAY      = 0.025; // seconds between one letter and the next

// ---- Cursor trail ----------------------------------------------------------
const float TRAIL_DURATION  = 0.10;  // seconds; higher = slower trail
const float TRAIL_ALPHA     = 1.00;  // trail strength (0.0 = off)

// ---- Enter ripple ----------------------------------------------------------
const float RIPPLE_ALPHA    = 0.0;  // ring strength (0.0 = off)
const float RIPPLE_RADIUS   = 2.0;   // final radius, in cell heights
const float RIPPLE_WIDTH    = 0.35;  // ring thickness, in cell heights
const float RIPPLE_WARP     = 3.0;   // how much the ring bends the text (px)
const float RIPPLE_DURATION = 0.45;  // seconds

// ---- Backspace shake -------------------------------------------------------
const float SHAKE_AMOUNT    = 2.0;   // pixels (0.0 = off)
const float SHAKE_SPEED     = 100.0;  // oscillation speed
const float SHAKE_DURATION  = 0.1;  // seconds

// ---------------------------------------------------------------------------

const float PI = 3.14159265;

float easeOutCubic(float x) { return 1.0 - pow(1.0 - x, 3.0); }

// Overshoots past 1.0 and settles back when BOUNCE > 0.
float easeOutBack(float x) {
    float c = BOUNCE;
    float y = x - 1.0;
    return 1.0 + (c + 1.0) * y * y * y + c * y * y;
}

float sdBox(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 res = iResolution.xy;
    float elapsed = iTime - iTimeCursorChange;

    float longest = max(max(LETTER_DURATION, TRAIL_DURATION),
                        max(max(WAVE_DURATION + WAVE_DELAY * WAVE_CELLS, RIPPLE_DURATION),
                            SHAKE_DURATION));
    if (elapsed >= longest) {
        fragColor = texture(iChannel0, fragCoord / res);
        return;
    }

    // Cursor rects: xy = top-left corner (origin bottom-left), zw = size
    vec4 cur = iCurrentCursor;
    vec4 prev = iPreviousCursor;
    vec2 size = cur.zw;
    vec2 curC = cur.xy + vec2(size.x, -size.y) * 0.5;
    vec2 prevC = prev.xy + vec2(prev.z, -prev.w) * 0.5;
    vec2 delta = curC - prevC;

    bool sameRow  = abs(delta.y) < 1.0;
    bool typed    = sameRow && delta.x > 0.0 && delta.x < size.x * 1.5;  // one letter forward
    bool erased   = sameRow && delta.x < 0.0 && delta.x > -size.x * 1.5; // one letter back
    // Enter: the cursor drops one row. Once the screen is full the text scrolls
    // instead and the cursor stays on the last row, jumping back to the left.
    bool movedDown = delta.y < -size.y * 0.5 && delta.y > -size.y * 1.5;
    bool scrolled  = sameRow && delta.x < -size.x * 1.5;
    bool newline   = movedDown || scrolled;
    vec2 rippleC   = movedDown ? prevC : curC;

    // ---- Displacements applied before sampling (wave, shake, ripple warp) ----
    vec2 offset = vec2(0.0);
    bool inRow = abs(fragCoord.y - prevC.y) <= size.y * 0.5;

    if (typed && WAVE_HEIGHT > 0.0 && inRow) {
        // k = 1 for the letter before the new one, 2 for the one before that...
        float k = floor((prevC.x - fragCoord.x) / size.x + 0.5);
        if (k >= 1.0 && k <= WAVE_CELLS) {
            float lt = clamp((elapsed - k * WAVE_DELAY) / WAVE_DURATION, 0.0, 1.0);
            float falloff = 1.0 - (k - 1.0) / WAVE_CELLS;
            offset.y -= sin(lt * PI) * WAVE_HEIGHT * size.y * falloff;
        }
    }

    if (erased && SHAKE_AMOUNT > 0.0 && inRow) {
        float st = clamp(elapsed / SHAKE_DURATION, 0.0, 1.0);
        offset.x += sin(elapsed * SHAKE_SPEED) * SHAKE_AMOUNT * (1.0 - st);
    }

    float rippleRing = 0.0;
    if (newline && (RIPPLE_ALPHA > 0.0 || RIPPLE_WARP > 0.0)) {
        float rt = clamp(elapsed / RIPPLE_DURATION, 0.0, 1.0);
        float radius = easeOutCubic(rt) * RIPPLE_RADIUS * size.y;
        vec2 fromC = fragCoord - rippleC;
        float dist = length(fromC);
        float ring = 1.0 - smoothstep(0.0, RIPPLE_WIDTH * size.y, abs(dist - radius));
        rippleRing = ring * (1.0 - rt);
        if (dist > 0.0) offset -= normalize(fromC) * RIPPLE_WARP * rippleRing;
    }

    fragColor = texture(iChannel0, (fragCoord + offset) / res);

    // ---- Letter animation ----------------------------------------------------
    float lt = clamp(elapsed / LETTER_DURATION, 0.0, 1.0);
    if (typed && lt < 1.0) {
        float e = easeOutBack(lt);         // may overshoot past 1.0
        float f = clamp(easeOutCubic(lt), 0.0, 1.0);
        vec2 local = fragCoord - prevC;
        vec2 hs = prev.zw * 0.5;
        // Let the bounce spill a bit outside the cell.
        vec2 area = hs * (1.0 + 0.25 * step(0.001, BOUNCE));
        if (abs(local.x) <= area.x && abs(local.y) <= area.y) {
            vec4 bg = texture(iChannel0, (prev.xy + vec2(1.0, -1.0)) / res);
            vec2 srcLocal = local;
            if (LETTER_STYLE == 0) srcLocal = local / max(mix(POP_START, 1.0, e), 0.05);
            if (LETTER_STYLE == 2) srcLocal = local + vec2(0.0, (1.0 - e) * hs.y);
            if (LETTER_STYLE == 3) srcLocal = local - vec2(0.0, (1.0 - e) * hs.y);

            vec4 glyph = bg;
            if (abs(srcLocal.x) <= hs.x && abs(srcLocal.y) <= hs.y) {
                glyph = texture(iChannel0, (prevC + srcLocal) / res);
            }

            bool inCell = abs(local.x) <= hs.x && abs(local.y) <= hs.y;
            if (LETTER_STYLE == 4) {
                float ink = clamp(length(glyph.rgb - bg.rgb) * 2.0, 0.0, 1.0);
                glyph.rgb = mix(glyph.rgb, iCurrentCursorColor.rgb, ink * (1.0 - f));
                if (inCell) fragColor = glyph;
            } else if (inCell) {
                fragColor = mix(bg, glyph, f);
            } else {
                // Overshoot outside the cell: draw only the letter's ink.
                float ink = clamp(length(glyph.rgb - bg.rgb) * 2.0, 0.0, 1.0);
                fragColor = mix(fragColor, glyph, ink * f);
            }
        }
    }

    // ---- Cursor trail --------------------------------------------------------
    float tt = clamp(elapsed / TRAIL_DURATION, 0.0, 1.0);
    if (tt < 1.0 && TRAIL_ALPHA > 0.0) {
        float e = easeOutCubic(tt);
        vec2 head = mix(prevC, curC, e);
        vec2 pa = fragCoord - prevC;
        vec2 ba = head - prevC;
        float h = clamp(dot(pa, ba) / max(dot(ba, ba), 1e-4), 0.0, 1.0);
        float d = sdBox(pa - ba * h, size * 0.5);
        float a = (1.0 - smoothstep(-1.0, 1.0, d)) * (1.0 - e) * mix(0.25, 1.0, h);
        if (typed) a *= 0.6;
        a *= TRAIL_ALPHA;
        fragColor = mix(fragColor, vec4(iCurrentCursorColor.rgb, 1.0), a);
    }

    // ---- Enter ripple ring ---------------------------------------------------
    if (rippleRing > 0.0 && RIPPLE_ALPHA > 0.0) {
        fragColor = mix(fragColor, vec4(iCurrentCursorColor.rgb, 1.0), rippleRing * RIPPLE_ALPHA);
    }
}
