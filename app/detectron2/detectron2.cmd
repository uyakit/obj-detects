@echo off


:: https://miyashinblog.com/detectron2/#toc4


cd  %~p1

set pathd_cmd=%~dp0
set pathd_png=%~dp1
set name_png=%~n1


echo [Detectron2] .cmd Dir. : %pathd_cmd%
echo [Detectron2] .png Dir. : %pathd_png%
echo [Detectron2] .png name : %name_png%

if not exist (%name_png%_Detectron2) (
	mkdir %name_png%_Detectron2
)
copy  %name_png%.png  %name_png%_Detectron2


if not %pathd_cmd%==C:\home\site\wwwroot\app\detectron2\ (
	:: --------------------------------------------------------------------------------
	:: # Output results by Detectron2
	
	:: https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#coco-instance-segmentation-baselines-with-mask-r-cnn
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml  --input %name_png%.png  --output %name_png%_InstanceSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml  --input %name_png%.png  --output %name_png%_InstanceSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_f10217.pkl
	copy  %name_png%_InstanceSegmentation.png  %name_png%_Detectron2
	copy  %name_png%_InstanceSegmentation.png  obj-detects_InstanceSegmentation.png
	del   %name_png%_InstanceSegmentation.png
	copy  %name_png%_InstanceSegmentation.csv  %name_png%_Detectron2
	del   %name_png%_InstanceSegmentation.csv
	
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml   --input %name_png%.png  --output %name_png%_PanopticSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-PanopticSegmentation/panoptic_fpn_R_50_3x/139514569/model_final_c10459.pkl
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml   --input %name_png%.png  --output %name_png%_PanopticSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_c10459.pkl
	copy  %name_png%_PanopticSegmentation.png  %name_png%_Detectron2
	copy  %name_png%_PanopticSegmentation.png  obj-detects_PanopticSegmentation.png
	del   %name_png%_PanopticSegmentation.png
	copy  %name_png%_PanopticSegmentation.csv  %name_png%_Detectron2
	del   %name_png%_PanopticSegmentation.csv
	
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x.yaml        --input %name_png%.png  --output %name_png%_Keypoints.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x/138363331/model_final_997cc7.pkl
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x.yaml        --input %name_png%.png  --output %name_png%_Keypoints.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_997cc7.pkl
	copy  %name_png%_Keypoints.png             %name_png%_Detectron2
	copy  %name_png%_Keypoints.png        obj-detects_Keypoints.png
	del   %name_png%_Keypoints.png
	copy  %name_png%_Keypoints.csv             %name_png%_Detectron2
	del   %name_png%_Keypoints.csv
	
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml           --input %name_png%.png  --output %name_png%_Detection.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-Detection/faster_rcnn_R_50_FPN_3x/137849458/model_final_280758.pkl
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml           --input %name_png%.png  --output %name_png%_Detection.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_280758.pkl
	copy  %name_png%_Detection.png             %name_png%_Detectron2
	copy  %name_png%_Detection.png        obj-detects_Detection.png
	del   %name_png%_Detection.png
	copy  %name_png%_Detection.csv             %name_png%_Detectron2
	del   %name_png%_Detection.csv
	
	del   %name_png%.png 
	:: --------------------------------------------------------------------------------
	:: # Zip results
	
	C:/home/python3111x64/python.exe  zip.py  %name_png%_Detectron2
	:: --------------------------------------------------------------------------------
	:: # for Previews on .html
	
	:: pwsh -Command Set-ItemProperty  obj-detects_InstanceSegmentation.png -name CreationTime   -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_InstanceSegmentation.png -name LastWriteTime  -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_InstanceSegmentation.png -name LastAccessTime -value $(Get-Date)
	
	:: pwsh -Command Set-ItemProperty  obj-detects_PanopticSegmentation.png -name CreationTime   -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_PanopticSegmentation.png -name LastWriteTime  -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_PanopticSegmentation.png -name LastAccessTime -value $(Get-Date)
	
	:: pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name CreationTime   -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name LastWriteTime  -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_Keypoints.png -name LastAccessTime -value $(Get-Date)
	
	:: pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name CreationTime   -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name LastWriteTime  -value $(Get-Date)
	:: pwsh -Command Set-ItemProperty  obj-detects_Detection.png -name LastAccessTime -value $(Get-Date)
	:: --------------------------------------------------------------------------------
) else (
	copy  %name_png%.png  obj-detects.png
	del   %name_png%.png
	:: --------------------------------------------------------------------------------
	:: # Output results by Detectron2
	
	:: https://github.com/facebookresearch/detectron2/blob/main/MODEL_ZOO.md#coco-instance-segmentation-baselines-with-mask-r-cnn
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml  --input %name_png%.png  --output %name_png%_InstanceSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml  --input obj-detects.png  --output obj-detects_InstanceSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_f10217.pkl
	copy  obj-detects_InstanceSegmentation.png  %name_png%_InstanceSegmentation.png
	copy  obj-detects_InstanceSegmentation.csv  %name_png%_InstanceSegmentation.csv
	del   obj-detects_InstanceSegmentation.csv
	copy  %name_png%_InstanceSegmentation.png  %name_png%_Detectron2
	copy  %name_png%_InstanceSegmentation.csv  %name_png%_Detectron2
	del   %name_png%_InstanceSegmentation.png
	del   %name_png%_InstanceSegmentation.csv
	
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml   --input %name_png%.png  --output %name_png%_PanopticSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-PanopticSegmentation/panoptic_fpn_R_50_3x/139514569/model_final_c10459.pkl
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml   --input obj-detects.png  --output obj-detects_PanopticSegmentation.png  --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_c10459.pkl
	copy  obj-detects_PanopticSegmentation.png  %name_png%_PanopticSegmentation.png
	copy  obj-detects_PanopticSegmentation.csv  %name_png%_PanopticSegmentation.csv
	del   obj-detects_PanopticSegmentation.csv
	copy  %name_png%_PanopticSegmentation.png  %name_png%_Detectron2
	copy  %name_png%_PanopticSegmentation.csv  %name_png%_Detectron2
	del   %name_png%_PanopticSegmentation.png
	del   %name_png%_PanopticSegmentation.csv
	
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x.yaml        --input %name_png%.png  --output %name_png%_Keypoints.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x/138363331/model_final_997cc7.pkl
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Keypoints/keypoint_rcnn_R_101_FPN_3x.yaml        --input obj-detects.png  --output obj-detects_Keypoints.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_997cc7.pkl
	copy  obj-detects_Keypoints.png  %name_png%_Keypoints.png
	copy  obj-detects_Keypoints.csv  %name_png%_Keypoints.csv
	del   obj-detects_Keypoints.csv
	copy  %name_png%_Keypoints.png  %name_png%_Detectron2
	copy  %name_png%_Keypoints.csv  %name_png%_Detectron2
	del   %name_png%_Keypoints.png
	del   %name_png%_Keypoints.csv
	
	:: C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml           --input %name_png%.png  --output %name_png%_Detection.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS detectron2://COCO-Detection/faster_rcnn_R_50_FPN_3x/137849458/model_final_280758.pkl
	C:/home/python3111x64/python.exe  detectron2.py --config-file ./configs/COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml           --input obj-detects.png  --output obj-detects_Detection.png             --opts MODEL.DEVICE cpu MODEL.WEIGHTS ./pre-models/model_final_280758.pkl
	copy  obj-detects_Detection.png  %name_png%_Detection.png
	copy  obj-detects_Detection.csv  %name_png%_Detection.csv
	del   obj-detects_Detection.csv
	copy  %name_png%_Detection.png  %name_png%_Detectron2
	copy  %name_png%_Detection.csv  %name_png%_Detectron2
	del   %name_png%_Detection.png
	del   %name_png%_Detection.csv
	:: --------------------------------------------------------------------------------
	:: # Zip results
	
	C:/home/python3111x64/python.exe  zip.py  %name_png%_Detectron2
	:: --------------------------------------------------------------------------------
)

set name_png=
set pathd_png=
set pathd_cmd=
