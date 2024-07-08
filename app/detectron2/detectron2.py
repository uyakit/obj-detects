# -*- coding: utf-8 -*-

# https://miyashinblog.com/detectron2/#toc4

import io
import os
import sys
import subprocess
import shutil

import argparse
import glob
import multiprocessing as mp
import numpy as np
import pandas as pd
import os
import tempfile
import time
import warnings
import cv2
import tqdm

from decimal import *

from detectron2.config import get_cfg
from detectron2.data.detection_utils import read_image
from detectron2.utils.logger import setup_logger

from predictor import VisualizationDemo

# constants
WINDOW_NAME = "COCO detections"

path_me = os.path.abspath(os.path.realpath(__file__)).replace(os.sep,'/')
pathd_me = os.path.abspath(os.path.dirname(path_me)).replace(os.sep,'/')
basename_me = os.path.splitext(os.path.basename(path_me))[0]
os.chdir(pathd_me)

path_png = os.path.abspath(sys.argv[1]).replace(os.sep,'/')
pathd_png = os.path.abspath(os.path.dirname(path_png)).replace(os.sep,'/')
basename_png = os.path.splitext(os.path.basename(path_png))[0]


 # args
     # config_file='./configs/COCO-PanopticSegmentation/panoptic_fpn_R_50_3x.yaml',
     # webcam=False,
     # video_input=None,
     # input=['office.png'],
     # output=None,
     # confidence_threshold=0.5,
     # opts=['MODEL.DEVICE', 'cpu', 'MODEL.WEIGHTS', 'detectron2://COCO-PanopticSegmentation/panoptic_fpn_R_50_3x/139514569/model_final_c10459.pkl']

# https://gist.github.com/AruniRC/7b3dadd004da04c80198557db5da4bda
className = {0: u'__background__',
             1: u'person',
             2: u'bicycle',
             3: u'car',
             4: u'motorcycle',
             5: u'airplane',
             6: u'bus',
             7: u'train',
             8: u'truck',
             9: u'boat',
             10: u'traffic light',
             11: u'fire hydrant',
             12: u'stop sign',
             13: u'parking meter',
             14: u'bench',
             15: u'bird',
             16: u'cat',
             17: u'dog',
             18: u'horse',
             19: u'sheep',
             20: u'cow',
             21: u'elephant',
             22: u'bear',
             23: u'zebra',
             24: u'giraffe',
             25: u'backpack',
             26: u'umbrella',
             27: u'handbag',
             28: u'tie',
             29: u'suitcase',
             30: u'frisbee',
             31: u'skis',
             32: u'snowboard',
             33: u'sports ball',
             34: u'kite',
             35: u'baseball bat',
             36: u'baseball glove',
             37: u'skateboard',
             38: u'surfboard',
             39: u'tennis racket',
             40: u'bottle',
             41: u'wine glass',
             42: u'cup',
             43: u'fork',
             44: u'knife',
             45: u'spoon',
             46: u'bowl',
             47: u'banana',
             48: u'apple',
             49: u'sandwich',
             50: u'orange',
             51: u'broccoli',
             52: u'carrot',
             53: u'hot dog',
             54: u'pizza',
             55: u'donut',
             56: u'cake',
             57: u'chair',
             58: u'couch',
             59: u'potted plant',
             60: u'bed',
             61: u'dining table',
             62: u'toilet',
             63: u'tv',
             64: u'laptop',
             65: u'mouse',
             66: u'remote',
             67: u'keyboard',
             68: u'cell phone',
             69: u'microwave',
             70: u'oven',
             71: u'toaster',
             72: u'sink',
             73: u'refrigerator',
             74: u'book',
             75: u'clock',
             76: u'vase',
             77: u'scissors',
             78: u'teddy bear',
             79: u'hair drier',
             80: u'toothbrush'}

def setup_cfg(args):
    # load config from file and command-line arguments
    cfg = get_cfg()
    # To use demo for Panoptic-DeepLab, please uncomment the following two lines.
    # from detectron2.projects.panoptic_deeplab import add_panoptic_deeplab_config  # noqa
    # add_panoptic_deeplab_config(cfg)
    cfg.merge_from_file(args.config_file)
    cfg.merge_from_list(args.opts)
    # Set score_threshold for builtin models
    cfg.MODEL.RETINANET.SCORE_THRESH_TEST = args.confidence_threshold
    cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = args.confidence_threshold
    cfg.MODEL.PANOPTIC_FPN.COMBINE.INSTANCES_CONFIDENCE_THRESH = args.confidence_threshold
    cfg.freeze()
    return cfg


def get_parser():
    parser = argparse.ArgumentParser(description="Detectron2 demo for builtin configs")
    parser.add_argument(
        "--config-file",
        default="configs/quick_schedules/mask_rcnn_R_50_FPN_inference_acc_test.yaml",
        metavar="FILE",
        help="path to config file",
    )
    parser.add_argument("--webcam", action="store_true", help="Take inputs from webcam.")
    parser.add_argument("--video-input", help="Path to video file.")
    parser.add_argument(
        "--input",
        nargs="+",
        help="A list of space separated input images; "
        "or a single glob pattern such as 'directory/*.jpg'",
    )
    parser.add_argument(
        "--output",
        help="A file or directory to save output visualizations. "
        "If not given, will show output in an OpenCV window.",
    )

    parser.add_argument(
        "--confidence-threshold",
        type=float,
        default=0.5,
        help="Minimum score for instance predictions to be shown",
    )
    parser.add_argument(
        "--opts",
        help="Modify config options using the command-line 'KEY VALUE' pairs",
        default=[],
        nargs=argparse.REMAINDER,
    )
    return parser


def test_opencv_video_format(codec, file_ext):
    with tempfile.TemporaryDirectory(prefix="video_format_test") as dir:
        filename = os.path.join(dir, "test_file" + file_ext)
        writer = cv2.VideoWriter(
            filename=filename,
            fourcc=cv2.VideoWriter_fourcc(*codec),
            fps=float(30),
            frameSize=(10, 10),
            isColor=True,
        )
        [writer.write(np.zeros((10, 10, 3), np.uint8)) for _ in range(30)]
        writer.release()
        if os.path.isfile(filename):
            return True
        return False


def main() -> None:
    
    mp.set_start_method("spawn", force=True)
    args = get_parser().parse_args()
    setup_logger(name="fvcore")
    logger = setup_logger()
    logger.info("Arguments: " + str(args))
    
    cfg = setup_cfg(args)
    
    demo = VisualizationDemo(cfg)
    
    print ('#INPUT  : ' + str(args.input[0]))
    print ('#OUTPUT : ' + str(args.output))
    
    if args.input:
        if len(args.input) == 1:
            args.input = glob.glob(os.path.expanduser(args.input[0]))
            assert args.input, "The input path(s) was not found"
        for path in tqdm.tqdm(args.input, disable=not args.output):
            # use PIL, to be consistent with evaluation
            img = read_image(path, format="BGR")
            start_time = time.time()
            predictions, visualized_output = demo.run_on_image(img)
            # ----------------------------------------------------------------
            # Output .csv
            # https://tt-tsukumochi.com/archives/1198#vk-htags-258c208d-53e5-453d-acd8-c3e332224cfd
            bounding_boxes = predictions["instances"].pred_boxes.tensor.cpu().numpy()
            
            data = {
                'Class ID': predictions["instances"].pred_classes.tolist(),
                'Class Name': list(map(lambda x: className[x+1], predictions["instances"].pred_classes.tolist())),  # https://stackoverflow.com/questions/65427337/what-do-the-class-labels-output-be-detectron-2-refer-to
                'Scores': predictions["instances"].scores.tolist(),
                'BoundingBox: X(min)': [round(bounding_boxes[i][0]) for i in range(len(predictions["instances"]))],
                'BoundingBox: Y(min)': [round(bounding_boxes[i][1]) for i in range(len(predictions["instances"]))],
                'BoundingBox: X(max)': [round(bounding_boxes[i][2]) for i in range(len(predictions["instances"]))],
                'BoundingBox: Y(max)': [round(bounding_boxes[i][3]) for i in range(len(predictions["instances"]))],
                'BoundingBox: X(center)': [round((bounding_boxes[i][0] + bounding_boxes[i][2]) * 0.5) for i in range(len(predictions["instances"]))],
                'BoundingBox: Y(center)': [round((bounding_boxes[i][1] + bounding_boxes[i][3]) * 0.5) for i in range(len(predictions["instances"]))]
            }
            
            df = pd.DataFrame(data)
            df = df.sort_values(['BoundingBox: X(min)', 'BoundingBox: Y(min)'], ascending=True)
            df.insert(loc=0, column='Count', value=[i + 1 for i in range(len(predictions["instances"]))])
            df.to_csv(os.path.splitext(str(args.output))[0] + '.csv', encoding='utf-8', index=False, header=True)
            # ----------------------------------------------------------------
            logger.info(
                "{}: {} in {:.2f}s".format(
                    path,
                    (
                        "detected {} instances".format(len(predictions["instances"]))
                        if "instances" in predictions
                        else "finished"
                    ),
                    time.time() - start_time,
                )
            )
            
            if args.output:
                if os.path.isdir(args.output):
                    assert os.path.isdir(args.output), args.output
                    out_filename = os.path.join(args.output, os.path.basename(path))
                else:
                    assert len(args.input) == 1, "Please specify a directory with args.output"
                    out_filename = args.output
                visualized_output.save(out_filename)
            else:
                cv2.namedWindow(WINDOW_NAME, cv2.WINDOW_NORMAL)
                cv2.imshow(WINDOW_NAME, visualized_output.get_image()[:, :, ::-1])
                if cv2.waitKey(0) == 27:
                    break  # esc to quit
    elif args.webcam:
        assert args.input is None, "Cannot have both --input and --webcam!"
        assert args.output is None, "output not yet supported with --webcam!"
        cam = cv2.VideoCapture(0)
        for vis in tqdm.tqdm(demo.run_on_video(cam)):
            cv2.namedWindow(WINDOW_NAME, cv2.WINDOW_NORMAL)
            cv2.imshow(WINDOW_NAME, vis)
            if cv2.waitKey(1) == 27:
                break  # esc to quit
        cam.release()
        cv2.destroyAllWindows()
    elif args.video_input:
        video = cv2.VideoCapture(args.video_input)
        width = int(video.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))
        frames_per_second = video.get(cv2.CAP_PROP_FPS)
        num_frames = int(video.get(cv2.CAP_PROP_FRAME_COUNT))
        basename = os.path.basename(args.video_input)
        codec, file_ext = (
            ("x264", ".mkv") if test_opencv_video_format("x264", ".mkv") else ("mp4v", ".mp4")
        )
        if codec == ".mp4v":
            warnings.warn("x264 codec not available, switching to mp4v")
        if args.output:
            if os.path.isdir(args.output):
                output_fname = os.path.join(args.output, basename)
                output_fname = os.path.splitext(output_fname)[0] + file_ext
            else:
                output_fname = args.output
            assert not os.path.isfile(output_fname), output_fname
            output_file = cv2.VideoWriter(
                filename=output_fname,
                # some installation of opencv may not support x264 (due to its license),
                # you can try other format (e.g. MPEG)
                fourcc=cv2.VideoWriter_fourcc(*codec),
                fps=float(frames_per_second),
                frameSize=(width, height),
                isColor=True,
            )
        assert os.path.isfile(args.video_input)
        for vis_frame in tqdm.tqdm(demo.run_on_video(video), total=num_frames):
            if args.output:
                output_file.write(vis_frame)
            else:
                cv2.namedWindow(basename, cv2.WINDOW_NORMAL)
                cv2.imshow(basename, vis_frame)
                if cv2.waitKey(1) == 27:
                    break  # esc to quit
        video.release()
        if args.output:
            output_file.release()
        else:
            cv2.destroyAllWindows()


if __name__ == "__main__":
    main()  # pragma: no cover
