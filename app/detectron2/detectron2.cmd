REM https://miyashinblog.com/detectron2/#toc4

cd  %~p1
REM --------------------------------------------------------------------------------
REM # Output results by Detectron2

REM https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#coco-instance-segmentation-baselines-with-mask-r-cnn
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml  --input %~n1.png  --output %~n1_InstanceSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_f10217.pkl
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x.yaml        --input %~n1.png  --output %~n1_Keypoints.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_997cc7.pkl
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml   --input %~n1.png  --output %~n1_PanopticSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_c10459.pkl
C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml           --input %~n1.png  --output %~n1_Detection.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_280758.pkl
REM --------------------------------------------------------------------------------
REM # Zip results

if not exist (%~n1_Detectron2) (
	mkdir %~n1_Detectron2
)

copy  %~n1.png                       %~n1_Detectron2
copy  %~n1_InstanceSegmentation.png  %~n1_Detectron2
copy  %~n1_Keypoints.png             %~n1_Detectron2
copy  %~n1_PanopticSegmentation.png  %~n1_Detectron2
copy  %~n1_Detection.png             %~n1_Detectron2

C:/home/python3111x64/python.exe  zip.py  %~p1%~n1_Detectron2
REM --------------------------------------------------------------------------------
REM # for Previews on .html

copy  %~n1_InstanceSegmentation.png  obj-detects_InstanceSegmentation.png
del   %~n1_InstanceSegmentation.png
pwsh -Command Set-ItemProperty       obj-detects_InstanceSegmentation.png -name CreationTime   -value $(Get-Date)
pwsh -Command Set-ItemProperty       obj-detects_InstanceSegmentation.png -name LastWriteTime  -value $(Get-Date)
pwsh -Command Set-ItemProperty       obj-detects_InstanceSegmentation.png -name LastAccessTime -value $(Get-Date)

copy  %~n1_PanopticSegmentation.png  obj-detects_PanopticSegmentation.png
del   %~n1_PanopticSegmentation.png
pwsh -Command Set-ItemProperty       obj-detects_PanopticSegmentation.png -name CreationTime   -value $(Get-Date)
pwsh -Command Set-ItemProperty       obj-detects_PanopticSegmentation.png -name LastWriteTime  -value $(Get-Date)
pwsh -Command Set-ItemProperty       obj-detects_PanopticSegmentation.png -name LastAccessTime -value $(Get-Date)

copy  %~n1_Keypoints.png        obj-detects_Keypoints.png
del   %~n1_Keypoints.png
pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name CreationTime   -value $(Get-Date)
pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name LastWriteTime  -value $(Get-Date)
pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name LastAccessTime -value $(Get-Date)

copy  %~n1_Detection.png        obj-detects_Detection.png
del   %~n1_Detection.png
pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name CreationTime   -value $(Get-Date)
pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name LastWriteTime  -value $(Get-Date)
pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name LastAccessTime -value $(Get-Date)
REM --------------------------------------------------------------------------------