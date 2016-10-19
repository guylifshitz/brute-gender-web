$(document).ready(function() {
$('input[type="checkbox"]').change(function() {
    $(this).parent('form').submit()
});
});