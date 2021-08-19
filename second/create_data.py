import copy
from pathlib import Path
import pickle

import fire

import second.data.kitti_dataset as kitti_ds
import second.data.nuscenes_dataset as nu_ds
from second.data.all_dataset import create_groundtruth_database

def kitti_data_prep(root_path):
    kitti_ds.create_kitti_info_file(root_path)#获取数据集中点云图像路径  kitti_infos
    kitti_ds.create_reduced_point_cloud(root_path)#获取相机视场内的点云,存到reduce中  reduce
    create_groundtruth_database("KittiDataset", root_path, Path(root_path) / "kitti_infos_train.pkl")# 创建真值数据库，真值的意思是数据只包含特殊类别的点云，只有车，人，等等物体的base info和label info，用于kiiti数据的数据增.  kitti_dbinfos_train

def nuscenes_data_prep(root_path, version, dataset_name, max_sweeps=10):
    nu_ds.create_nuscenes_infos(root_path, version=version, max_sweeps=max_sweeps)
    name = "infos_train.pkl"
    if version == "v1.0-test":
        name = "infos_test.pkl"
    create_groundtruth_database(dataset_name, root_path, Path(root_path) / name)

if __name__ == '__main__':
    fire.Fire()
