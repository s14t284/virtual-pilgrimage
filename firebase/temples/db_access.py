# 使用するライブラリの読み込み
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud.firestore import GeoPoint
import pandas as pd

def main():
    """
    firestoreデータにアクセス
    """
    
    # 秘密鍵によるfirebaseに認証を行う
    cred = credentials.Certificate('virtual-pilgrimage-dev-firebase-adminsdk-fnt9u-dbd50504a7.json')
    firebase_admin.initialize_app(cred)

    # firestoreにアクセスする
    db = firestore.client()

    """
    四国八十八か所のお寺の情報をcsvから読み込む
    """
    
    # pandasのDataFrameでcsvからデータを読み込む
    df = pd.read_csv("temple_info_update.csv",encoding="utf-8")
    
    # データの結びつけ
    """
    - address:住所
    - distance:徒歩距離(m)
    - geoPoint:[緯度(北緯),経度(東経)]
    - id:お遍路の番号
    - images:画像のパス
    - stamp_images:スタンプの画像パス
    - name:名前
    - prefecture:住所[:3]
    """
    # 各種リストの作成
    address = df["住所"].to_list()
    distance = df["徒歩距離(m)"].to_list()
    geo_n = df["緯度(北緯)"].to_list()
    geo_t = df["経度(東経)"].to_list()
    ids = df["お遍路の番号"].to_list()
    name = df["名前"].to_list()
    geoPoint = make_geopoint(geo_n,geo_t)
    image_path = make_image_path(ids)
    stamp_image_path = make_stamp_image_path(ids)
    prefecture = [add[:3] for add in address]

    """
    firestoreにデータを書き込む
    """
    
    for i,id_ in enumerate(ids):
        # firestoreのtemplesのid_(1,2,3,4,...)にアクセス
        ref = db.collection(u'temples').document(str(id_))
        # 各種データを書き込む
        ref.set({
            u'address':address[i],
            u'distance':distance[i],
            u'geoPoint':geoPoint[i],
            u'id':id_,
            u'images':image_path[i],
            u'stamp_images':stamp_image_path[i],
            u'name':name[i],
            u'prefecture':prefecture[i]
        })

    return

"""
各種関数の定義
"""
# 経度、緯度のデータをもとにGeoPoint型のデータを作成する関数の作成
def make_geopoint(geo_n,geo_t):
    geoPoint = []
    
    # GeoPoint型のデータの作成
    for n,t in zip(geo_n,geo_t):
        geoPoint.append(GeoPoint(n,t))
    
    return geoPoint


# storageにある.jegの画像ファイルへのパスを作成する関数
def make_image_path(ids):
    image_list = []

    # TODO: 1つのパス(1.jpg)に対してのみしか対応できていないので改良必要
    for id_ in ids:
        image_path = "https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-dev.appspot.com/o/temples%2F"+str(id_)+"%2F1.jpg?alt=media&token=6fe4c2ed-b204-4837-9c56-3b72f24e1186"
        image_list.append([image_path])

    return image_list

def make_stamp_image_path(ids):
    stamp_image_list = []

    # TODO: 1つのパス(1.jpg)に対してのみしか対応できていないので改良必要
    for id_ in ids:
        image_path = "https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-dev.appspot.com/o/temples%2F"+str(id_)+"%2Fstamp.jpg?alt=media&token=6fe4c2ed-b204-4837-9c56-3b72f24e1186"
        stamp_image_list.append([image_path])

    return stamp_image_list

main()
