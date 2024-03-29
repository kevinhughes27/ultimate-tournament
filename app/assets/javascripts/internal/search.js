var searchTimeout;

$(document).ready(function() {
  var $searchInput = $('#search-form').find('input#search');

  if ($searchInput.length == 1) {
    length = $searchInput.val().length * 2;
    $searchInput.focus();
    $searchInput[0].setSelectionRange(length, length);
  }

  $('#search-form').on('input', function() {
    clearTimeout(searchTimeout);

    searchTimeout = setTimeout(function() {
      $('#search-form').submit();
    }, 500);
  });
});
