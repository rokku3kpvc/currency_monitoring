App.rates = App.cable.subscriptions.create("RatesChannel", {
    connected() {
        return console.log('connected to socket');
    },

    disconnected() {
        return console.log('disconnected from socket');
    },

    received(data) {
        console.log(data);
        let updated_rate = data['rate'];
        updateRate(updated_rate);
    }
}
);

function updateRate(rate) {
    let rateContainer = $('.rate-data');
    rateContainer.empty();
    rateContainer.append(rate)
}