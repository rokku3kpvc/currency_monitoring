$(document).on('turbolinks:load', function() {
    let moscowDateTime = moment().format('MMMM D, YYYY HH:mm');

    $('#datetimepicker-rate').datetimepicker({
        format: 'MMMM D, YYYY HH:mm',
        stepping: 1,
        startDate: moscowDateTime,
        minDate: Date(),
        // maxDate: new Date(Date.now() + (365 * 24 * 60 * 60 * 1000)),
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
    updateCurrencyRate();
});

function updateDateTimeValue() {
    let lastForceTime = $('.previous-forced-time').html();
    $('.datetimepicker-input').val(lastForceTime);
}

function updateCurrencyRate() {
    let lastForceRate = $('.previous-forced-rate').html();
    $('#currency_rate').val(lastForceRate);
}