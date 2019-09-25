$(document).on('turbolinks:load', function() {
    $('#datetimepicker1').datetimepicker({
        format: 'MMMM D, YYYY h:mm A',
        stepping: 15,
        minDate: Date(),
        maxDate: new Date(Date.now() + (365 * 24 * 60 * 60 * 1000)),
        sideBySide: true,
        icons: {
            up: 'fas fa-sort-up',
            down: 'fas fa-sort-down',
            previous: 'fas fa-chevron-left',
            next: 'fas fa-chevron-right',
            close: 'fas fa-times'
        },
        buttons: {showClose: true }
    });

    updateDateTimeValue();
});

function updateDateTimeValue() {
    let lastForceTime = $('.previous-forced-time').html();
    $('.datetimepicker-input').val(lastForceTime);
}