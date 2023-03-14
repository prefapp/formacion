function selectOnlyThis1(id) {
  var myCheckbox1 = document.getElementsByName("myCheckbox1");
  Array.prototype.forEach.call(myCheckbox1, function (el) {
    el.checked = false;
  });
  id.checked = true;
}

function selectOnlyThis2(id) {
  var myCheckbox2 = document.getElementsByName("myCheckbox2");
  Array.prototype.forEach.call(myCheckbox2, function (el) {
    el.checked = false;
  });
  id.checked = true;
}

function selectOnlyThis3(id) {
  var myCheckbox3 = document.getElementsByName("myCheckbox3");
  Array.prototype.forEach.call(myCheckbox3, function (el) {
    el.checked = false;
  });
  id.checked = true;
}
