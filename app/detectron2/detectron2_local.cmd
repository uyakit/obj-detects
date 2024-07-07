REM https://miyashinblog.com/detectron2/#toc4

cd  %~p1

set pathd_now=%~p1
set name_png=%~n1

echo [Detectron2] Current Dir. : %pathd_now%
echo [Detectron2] Target.      : %name_png%

if not exist (%name_png%_Detectron2) (
	mkdir %name_png%_Detectron2
)
copy  %name_png%.png %name_png%_Detectron2
REM --------------------------------------------------------------------------------
REM # Output results by Detectron2

REM https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#coco-instance-segmentation-baselines-with-mask-r-cnn
REM C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml  --input %name_png%.png  --output %name_png%_InstanceSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml  --input %name_png%.png  --output %name_png%_InstanceSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_f10217.pkl
copy  %name_png%_InstanceSegmentation.png  %name_png%_Detectron2

REM C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x.yaml        --input %name_png%.png  --output %name_png%_Keypoints.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x/138363331/model_final_997cc7.pkl
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x.yaml        --input %name_png%.png  --output %name_png%_Keypoints.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_997cc7.pkl
copy  %name_png%_Keypoints.png             %name_png%_Detectron2

REM C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml   --input %name_png%.png  --output %name_png%_PanopticSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-PanopticSegmentation/panoptic_fpn_R_50_3x/139514569/model_final_c10459.pkl
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml   --input %name_png%.png  --output %name_png%_PanopticSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_c10459.pkl
copy  %name_png%_PanopticSegmentation.png  %name_png%_Detectron2

REM C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml           --input %name_png%.png  --output %name_png%_Detection.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-Detection/faster_rcnn_R_50_FPN_3x/137849458/model_final_280758.pkl
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml           --input %name_png%.png  --output %name_png%_Detection.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_280758.pkl
copy  %name_png%_Detection.png             %name_png%_Detectron2
REM --------------------------------------------------------------------------------
REM # Zip results

C:/home/python3111x64/python.exe  zip.py  %name_png%_Detectron2
REM --------------------------------------------------------------------------------
REM # for Previews on .html

copy  %name_png%_InstanceSegmentation.png  obj-detects_InstanceSegmentation.png
del   %name_png%_InstanceSegmentation.png
REM pwsh -Command Set-ItemProperty       obj-detects_InstanceSegmentation.png -name CreationTime   -value $(Get-Date)
REM pwsh -Command Set-ItemProperty       obj-detects_InstanceSegmentation.png -name LastWriteTime  -value $(Get-Date)
REM pwsh -Command Set-ItemProperty       obj-detects_InstanceSegmentation.png -name LastAccessTime -value $(Get-Date)

copy  %name_png%_PanopticSegmentation.png  obj-detects_PanopticSegmentation.png
del   %name_png%_PanopticSegmentation.png
REM pwsh -Command Set-ItemProperty       obj-detects_PanopticSegmentation.png -name CreationTime   -value $(Get-Date)
REM pwsh -Command Set-ItemProperty       obj-detects_PanopticSegmentation.png -name LastWriteTime  -value $(Get-Date)
REM pwsh -Command Set-ItemProperty       obj-detects_PanopticSegmentation.png -name LastAccessTime -value $(Get-Date)

copy  %name_png%_Keypoints.png        obj-detects_Keypoints.png
del   %name_png%_Keypoints.png
REM pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name CreationTime   -value $(Get-Date)
REM pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name LastWriteTime  -value $(Get-Date)
REM pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name LastAccessTime -value $(Get-Date)

copy  %name_png%_Detection.png        obj-detects_Detection.png
del   %name_png%_Detection.png
REM pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name CreationTime   -value $(Get-Date)
REM pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name LastWriteTime  -value $(Get-Date)
REM pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name LastAccessTime -value $(Get-Date)
REM --------------------------------------------------------------------------------