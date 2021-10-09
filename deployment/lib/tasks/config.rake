namespace :config do
  namespace :task_definition do
    desc "arn から cli が食える task-definition.json を生成する"
    task :fetch, ['target', 'task_def_arn'] do |t, args|
      # 既存task defを取得する
      # tmpファイルにtask-definition.jsonを書き込む
    end
  end
end
