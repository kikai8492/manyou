require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
      # 1. new_task_pathに遷移する（新規作成ページに遷移する）
      # ここにnew_task_pathにvisitする処理を書く
      visit new_task_path
      # 2. 新規登録内容を入力する
      #「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄にタスクのタイトルと内容をそれぞれ入力する
      # ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
      fill_in 'text', with: 'task'
      fill_in 'content', with: 'task'
      fill_in 'expired_at', with: '002023-08-18'
      #textはタスク名のtext_fieldのid
      # ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
      # 3. 「登録する」というvalue（表記文字）のあるボタンをクリックする
      # ここに「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
      click_on ('タスクを追加する')
      # 4. clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
      # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
      # ここにタスク詳細ページに、テストコードで作成したデータがタスク詳細画面にhave_contentされているか（含まれているか）を確認（期待）するコードを書く
      expect(page).to have_content 'task'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを作成
        FactoryBot.create(:task, not_started_yet: 'task1', expired_at: '002023-08-18')
        FactoryBot.create(:task, not_started_yet: 'task2', expired_at: '002023-08-19')
        # タスク一覧ページに遷移
        visit tasks_path
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task2'
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
      task = FactoryBot.create(:task, not_started_yet: 'task')
      visit task_path(task)
      expect(page).to have_content 'task'
      end
    end
  end
  context '終了期限でソートするを押した場合' do
    let!(:task1) { Task.create(not_started_yet: "task1", content: "content1", expired_at: '002023-08-19') }
    let!(:task2) { Task.create(not_started_yet: "task2", content: "content2", expired_at: '002023-08-18') }
    it '終了期限が一番近いタスクが一番上に表示される' do
      visit tasks_path
      click_on '終了期限でソートする'
      expect(page.text).to match(/#{task2.not_started_yet}[\s\S]*#{task1.not_started_yet}/)
    end
  end
end