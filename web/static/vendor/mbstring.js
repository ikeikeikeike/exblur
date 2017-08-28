String.prototype.mbLength = function() {
  var len = 0;
  for (var i = 0; i < this.length; i++) {
    if (this.charAt(i).isMultibyte()) {
      len += 2;
    } else {
      len += 1;
    }
  }
  return len;
}
String.prototype.mbSubstr = function() {
  var fromByte = arguments[0];
  var retByte = arguments[1];

  var len = 0;
  var i;
  for (i = 0; fromByte > len; i++) {
    if (this.charAt(i).isMultibyte()) {
      len += 2;
    } else {
      len += 1;
    }
  }
  var from = i;

  len = 0;
  var retLen = 0;
  while(retByte > len) {
    if (this.charAt(i).isMultibyte()) {
      len = len + 2;
    } else {
      len = len + 1;
    }
    retLen++;
    i++;
  }
  return this.substr(from, retLen);
}
String.prototype.isMultibyte = function() {
  var c = this.charCodeAt(0);
  // Unicode : 0x0 ～ 0x80, 0xf8f0, 0xff61 ～ 0xff9f, 0xf8f1 ～ 0xf8f3
  if ((c >= 0x0 && c <= 0x80) || (c == 0xf8f0) || (c >= 0xff61 && c <= 0xff9f) || (c >= 0xf8f1 && c <= 0xf8f3)) {
    return false;
  } else {
    return true;
  }
}
