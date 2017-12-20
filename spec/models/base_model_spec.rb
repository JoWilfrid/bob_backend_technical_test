# frozen_string_literal: true

require 'models/base_model'

RSpec.describe BaseModel do
  let(:subject_with_bar) do
    class SubjectWithBar < BaseModel
      attr_accessor :bar
    end

    SubjectWithBar
  end

  describe '#initialize' do
    it 'should init without params' do
      expect(BaseModel.new).not_to be_nil
    end

    it 'should not set any attributes if not declared' do
      object = BaseModel.new(foo: :bar)

      expect(object.instance_variable_get(:@foo)).to be_nil
    end

    it 'should set attributes if declared' do
      object = subject_with_bar.new(bar: :foo)

      expect(object.instance_variable_get(:@bar)).to eq :foo
    end
  end
end
