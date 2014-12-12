// Clamps a value between some minimum and maximum
Math.clamp = function clamp(min, value, max) {
  return Math.min(Math.max(value, min), max);
};

