# firestore - temples 
四国八十八か所のお寺の情報をfirestoreにインポートするコード
## Requirements
### HomeBrewでのインストール方法
```
$ brew install python3
$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$ python3 get-pip.py
$ pip install -r requirements.txt
```
### firebaseにアクセス方法
#### 秘密鍵の発行方法
~.jsonのJSON形式の秘密鍵が発行して用いる（今後はWEB APIでのアクセスに変更したい）
[秘密鍵の発行についてはこのサイトを参考にしてください](https://qiita.com/Mikumirai/items/f8a2ead6a6a1a4f57df8#api%E3%82%AD%E3%83%BC%E3%82%92%E3%82%82%E3%81%A3%E3%81%A6%E3%81%93%E3%82%88%E3%81%86)
#### ディレクトリ構造
```
images
README.md
csv_data_check.ipynb
db_access.py
distant_median.ipynb
requirements.txt
temple_info.csv
temple_info_update.csv
~.json ←追加
```
db_access.pyとcsv_data_check.ipynbのパスを発行されたJSONファイルの名前に変更してください
（envファイルで管理するのがいいかもしれない）
## Setup
### notebook
```
jupyter notebook
```
### python
```
python db_access.py
--key_path KEY_PATH.json
--data_path TEMPLE_DATA.csv
--env [dev or prd]
```
