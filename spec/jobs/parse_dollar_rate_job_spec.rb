require 'rails_helper'

RSpec.describe ParseDollarRateJob, type: :job do
  ActiveJob::Base.queue_adapter = :test
  describe 'when perform' do
    let(:cbr_answer) { 'https://www.cbr.ru/currency_base/daily/' }
    let(:x_path){ '//*[@id="content"]/table/tbody/tr[12]/td[5]' }
    let(:job){ described_class.new }

    before do
      job.instance_eval{ initialize_vars }
      job.instance_eval{ parse_usd_rate }
      job.instance_eval{ update_rate }
      job.actual_rate.save
    end

    it 'should enqueued' do
      expect { described_class.perform_later }
          .to have_enqueued_job.on_queue('default')
    end

    it 'should initialize vars' do
      expect(job.cbr).to eq(cbr_answer)
      expect(job.usd_xpath).to eq(x_path)
    end

    it 'should parse usd rate from cbr' do
      expect(job.usd_rate).to be_kind_of(Float)
    end

    it 'should create valid rate' do
      expect(job.actual_rate).to be_valid
    end
  end
end
