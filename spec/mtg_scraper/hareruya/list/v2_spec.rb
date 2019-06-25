# frozen_string_literal: true

RSpec.describe MtgScraper::Hareruya::List::V2 do

  let(:page){ page = MtgScraper::Page.new(url) }
  let(:html){ page.html }
  let(:list){ MtgScraper::Hareruya::List::V2.new(html) }

  describe '#each' do

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(list).to respond_to(:each) }
      it do
        count = 0
        list.each do |c|
          count += 1
        end
        expect(count).to eq list.size
      end
    end

  end

  describe '#size' do

    subject{ list.size }

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(subject).to eq 60 }
    end

  end

  describe '#[]' do

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }

      example 'english foil' do
        expect(list[0]).to eq(
          name: '恩寵の天使',
          english_name: 'Angel of Grace',
          language: 'english',
          price: 3000,
          basic_land: false,
          foil: true,
          card_set_code: 'RNA',
          token: false,
        )
      end

      example 'japanese non-foil' do
        expect(list[3]).to eq(
          name: '恩寵の天使',
          english_name: 'Angel of Grace',
          language: 'japanese',
          price: 380,
          basic_land: false,
          foil: false,
          card_set_code: 'RNA',
          token: false,
        )
      end

      example 'range' do
        expect(list[0..2].class).to eq Array
        expect(list[0..2].size).to eq 3
      end

    end

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=19' }

      example 'basic land' do
        expect(list[22]).to eq(
          name: '平地',
          english_name: 'Plains',
          language: 'japanese',
          price: 80,
          basic_land: true,
          foil: false,
          card_set_code: 'RNA',
          token: false,
        )
      end

    end

    context 'reservation' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=208' }

      example 'japanese' do
        expect(list[0]).to eq(
          name: '大いなる創造者、カーン',
          english_name: 'Karn, the Great Creator',
          language: 'japanese',
          price: 1400,
          basic_land: false,
          foil: false,
          card_set_code: 'WAR',
          token: false,
        )
      end

      example 'english' do
        expect(list[1]).to eq(
          name: '大いなる創造者、カーン',
          english_name: 'Karn, the Great Creator',
          language: 'english',
          price: 1400,
          basic_land: false,
          foil: false,
          card_set_code: 'WAR',
          token: false,
        )
      end

      example 'other version' do
        expect(list[2]).to eq(
          name: '大いなる創造者、カーン',
          english_name: 'Karn, the Great Creator',
          language: 'japanese',
          price: 2000,
          basic_land: false,
          foil: false,
          card_set_code: 'WAR',
          token: false,
          version: '絵違い',
        )
      end

    end

    context 'Brothers Yamazaki' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=53&page=11' }

      example do
        expect(list[37]).to eq(
          name: '山崎兄弟',
          english_name: 'Brothers Yamazaki',
          language: 'japanese',
          price: 150,
          basic_land: false,
          foil: false,
          card_set_code: 'CHK',
          token: false,
          version: 'A',
        )
      end

      example do
        expect(list[38]).to eq(
          name: '山崎兄弟',
          english_name: 'Brothers Yamazaki',
          language: 'english',
          price: 50,
          basic_land: false,
          foil: false,
          card_set_code: 'CHK',
          token: false,
          version: 'B',
        )
      end

    end

    context 'Japanese name only token' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=117' }

      example do
        expect(list[0]).to eq(
          name: '天使トークン',
          english_name: nil,
          language: 'english',
          price: 60,
          basic_land: false,
          foil: false,
          card_set_code: 'M14',
          token: true,
        )
      end

    end

    context 'omitted letter' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=128&page=18' }

      example do
        expect(list[12]).to eq(
          name: '平地',
          english_name: 'Plains',
          language: 'japanese',
          price: 100,
          basic_land: true,
          foil: true,
          card_set_code: 'M15',
          token: false,
        )

        expect(list[13]).to eq(
          name: '平地',
          english_name: 'Plains',
          language: 'english',
          price: 100,
          basic_land: true,
          foil: true,
          card_set_code: 'M15',
          token: false,
        )
      end

    end

  end

  describe 'category_list' do

    subject{ list.category_list }

    context do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it do
        expect(subject.size).to eq 138
        expect(subject[1][:name]).to eq 'ラヴニカの献身'
        expect(subject[1][:id]).to eq 188
      end
    end

  end

  describe 'next_page_url' do

    subject{ list.next_page_url }

    context 'first page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(subject).to eq 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=2' }
    end

    context 'middle page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=5' }
      it{ expect(subject).to eq 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=6' }
    end

    context 'last page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188&page=19' }
      it{ expect(subject).to eq nil }
    end

    context 'no pagination' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search' }
      it{ expect(subject).to eq nil }
    end

  end

  describe 'total_page' do

    subject{ list.total_page }

    context 'valid page' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search?cardset=188' }
      it{ expect(subject).to eq 19 }
    end

    context 'no pagination' do
      let(:url){ 'https://www.hareruyamtg.com/ja/products/search' }
      it{ expect(subject).to eq nil }
    end

  end

end
