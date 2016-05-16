<script>
if (navigator.userAgent.indexOf('Android') > 0) {
  document.write("ここにAndroidに表示したい項目");
} else if (navigator.userAgent.indexOf('iPhone') > 0 || navigator.userAgent.indexOf('iPad') > 0 || navigator.userAgent.indexOf('iPod') > 0) {
  document.write("ここにiOSに表示したい項目");
} else {
  document.write("ここにそれ以外のOSに表示したい項目");
}
</script>
