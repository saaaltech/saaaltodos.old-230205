/// Whether running in debug mode.
///
/// 1. Principle: code in `assets` will run in debug mode.
/// 2. Final variable rather than getter, in order to save cost. (see [_debug])
///
final debug = _debug;
bool get _debug {
  bool flag = false;
  assert(flag = true);
  return flag;
}
