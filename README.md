---
title: "[Obj. Detect by Detectron2 | README](https://obj-detects.azurewebsites.net/public/README.html)"
date: Released under the [MIT License](https://opensource.org/licenses/mit-license.php)
---


### Introduction

<p style="text-indent:2em; font-size: 115%;">

Provide some major types of [object detection](https://en.wikipedia.org/wiki/Object_detection) results by [Detectron2](https://github.com/facebookresearch/detectron2) for any picture .
</p>

### Requirements

<p style="text-indent:2em; font-size: 115%;">

- For the server machine where this web application is deployed, <font color="MediumSeaGreen">RAM 8 GB or more</font> required.

### Installation

<p style="text-indent:2em; font-size: 115%;">
Available now; just prepare <font color="MediumSeaGreen">a picture</font> to be used for the object detection.
</p>

### Usage

<p style="text-indent:3em; font-size: 115%;">

1. Visit the [main site](https://obj-detects.azurewebsites.net/).

2. Specify the .png file to be obj. detected.

3. Click 'Download .png' button to download a set of result pictures, which will take <font color="MediumSeaGreen">a couple of minutes</font>.
</p>

![](obj-detects.gif){ width=90% }
<br>
<br>


### Baseline models used

For details, refer to [the official documentation](https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md).


| Name | Model | Link |
| :-: | :------------ | :------------ |
| InstanceSegmentation | [Mask R-CNN: R50-FPN(3x) <br> [137849600]](https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#coco-instance-segmentation-baselines-with-mask-r-cnn) |  [model_final_f10217.pkl](https://dl.fbaipublicfiles.com/detectron2/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl) |
| PanopticSegmentation | [Panoptic FPN: R50-FPN(3x) <br> [139514569]](https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#coco-panoptic-segmentation-baselines-with-panoptic-fpn) |  [model_final_c10459.pkl](https://dl.fbaipublicfiles.com/detectron2/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x/139514569/model_final_c10459.pkl)  |
| Keypoints | [Keypoint R-CNN: R101-FPN(3x) <br> [138363331]](https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#coco-person-keypoint-detection-baselines-with-keypoint-r-cnn) |  [model_final_997cc7.pkl](https://dl.fbaipublicfiles.com/detectron2/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x/138363331/model_final_997cc7.pkl)  |
| Detection | [Faster R-CNN: R50-FPN(3x) <br> [137849458]](https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#faster-r-cnn) | [model_final_280758.pkl](https://dl.fbaipublicfiles.com/detectron2/COCO-Detection/faster_rcnn_R_50_FPN_3x/137849458/model_final_280758.pkl)  |
