// DO NOT EDIT! This test has been generated by /html/canvas/tools/gentest.py.
// OffscreenCanvas test in a worker:2d.text.measure.fontBoundingBox
// Description:Testing fontBoundingBox for OffscreenCanvas
// Note:

importScripts("/resources/testharness.js");
importScripts("/html/canvas/resources/canvas-tests.js");

var t = async_test("Testing fontBoundingBox for OffscreenCanvas");
var t_pass = t.done.bind(t);
var t_fail = t.step_func(function(reason) {
    throw reason;
});
t.step(function() {

  var canvas = new OffscreenCanvas(100, 50);
  var ctx = canvas.getContext('2d');

  var f = new FontFace("CanvasTest", "url('/fonts/CanvasTest.ttf')");
  let fonts = (self.fonts ? self.fonts : document.fonts);
  f.load();
  fonts.add(f);
  fonts.ready.then(function() {
      ctx.font = '50px CanvasTest';
      ctx.direction = 'ltr';
      ctx.align = 'left'
      // approx_equals because font metrics may be rounded slightly differently by different platforms/browsers.
      assert_approx_equals(ctx.measureText('A').fontBoundingBoxAscent, 50 * 1745 / 1024, 1, "unexpected fontBoundingBoxAscent");
      assert_approx_equals(ctx.measureText('A').fontBoundingBoxDescent, 50 * 805 / 1024, 1, "unexpected fontBoundingBoxDescent");

      assert_approx_equals(ctx.measureText('ABCD').fontBoundingBoxAscent, 50 * 1745 / 1024, 1, "unexpected fontBoundingBoxAscent");
      assert_approx_equals(ctx.measureText('ABCD').fontBoundingBoxDescent, 50 * 805 / 1024, 1, "unexpected fontBoundingBoxDescent");
  }).then(t_pass, t_fail);
});
done();