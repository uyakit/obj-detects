/**
Copyright (c) 2024 Yuya KITANO
Released under the MIT license
https://opensource.org/licenses/mit-license.php
*/

'use strict';

const express = require("express");
const router = express.Router();
const path = require("path");
const fs = require('fs');
const subproc = require('child_process');
const multer  = require('multer');

const multerStorage = multer.diskStorage({
	destination (req, file, cb) {
		cb(null, './app/detectron2/');
	},
	filename (req, file, cb) {
		// https://github.com/expressjs/multer/issues/1104#issuecomment-1155334173
		file.originalname = Buffer.from(file.originalname, 'latin1').toString('utf8');
		cb(null, file.originalname);
	}
});

const upload = multer({
	storage: multerStorage
});

//==================================================================
function copyf(path_from, path_to)
{
	fs.copyFileSync(path_from, path_to)
	
	const dnow = new Date();
	fs.utimes(path_to, dnow, dnow, e => {
		if (e) console.log( e.message );
	});
}
//==================================================================
function exec_detectron2(path_png)
{
	let fname_png = path.basename(path_png)
	// ------------------------------------------------------
	subproc.execSync('"' + path.join(path.resolve(''), '/app/detectron2/detectron2.cmd') + '"  "' + path_png + '"');
	// ------------------------------------------------------
}
//==================================================================
function clearPngMshStl_init(dir)
{
	const arrDirFiles = fs.readdirSync(dir, { withFileTypes: true });
	const arrFiles = arrDirFiles.filter(dirent => dirent.isFile()).map(({ name }) => name);
	
	arrFiles.forEach(fname => {
		if (path.basename(fname) == 'blockSpinner.png'
									|| path.basename(fname) == 'obj-detects_InstanceSegmentation.png'
									|| path.basename(fname) == 'obj-detects_PanopticSegmentation.png'
									|| path.basename(fname) == 'obj-detects_Keypoints.png'
									|| path.basename(fname) == 'obj-detects_Detection.png'
									|| path.parse(fname).ext == ".msh"
									|| path.parse(fname).ext == ".stl") {
			
			fs.unlink(path.join(dir, fname), (error) => {
				if (error != null) {
					console.log(error);
				} else {
					console.log(path.join(dir, fname) + " : deleted");
				}
			});
		}
	});
}
//==================================================================
function clearPngMshStl_all(dir)
{
	const arrDirFiles = fs.readdirSync(dir, { withFileTypes: true });
	// ------------------------------------------------------
	const arrFiles = arrDirFiles.filter(dirent => dirent.isFile()).map(({ name }) => name);
	
	arrFiles.forEach(fname => {
		if (path.parse(fname).ext == ".zip" || path.parse(fname).ext == ".png" || path.parse(fname).ext == ".msh" || path.parse(fname).ext == ".stl") {
			fs.unlink(path.join(dir, fname), (err) => {
				if (err != null) {
					console.log(err);
				} else {
					console.log(path.join(dir, fname) + " : deleted");
				}
			});
		}
	});
	// ------------------------------------------------------
	const arrDirs = arrDirFiles.filter(dirent => dirent.isDirectory()).map(({ name }) => name);
	
	arrDirs.forEach(dname => {
		if (dname.endsWith('_Detectron2')) {
			fs.rmdir(path.join(dir, dname), { recursive: true }, (err) => {
				if (err != null) {
					console.log(err);
				} else {
					console.log(path.join(dir, dname) + " : deleted");
				}
			});
		}
	});
	// ------------------------------------------------------
}
//==================================================================
// https://zenn.dev/wkb/books/node-tutorial/viewer/todo_03

// -------------------------------------------------------------------------------------------
router.get("/", (req, res) => {
	clearPngMshStl_all("./app/detectron2/");
	copyf("blockSpinner.png","./app/detectron2/blockSpinner.png");
	copyf("obj-detects_InstanceSegmentation.png","./app/detectron2/obj-detects_InstanceSegmentation.png");
	copyf("obj-detects_PanopticSegmentation.png","./app/detectron2/obj-detects_PanopticSegmentation.png");
	copyf("obj-detects_Keypoints.png","./app/detectron2/obj-detects_Keypoints.png");
	copyf("obj-detects_Detection.png","./app/detectron2/obj-detects_Detection.png");
	res.render("./index.ejs");
});
// -------------------------------------------------------------------------------------------
function procSub(req, res, next)
{
	let fname_png = path.basename(req.files[0].path)
	
	clearPngMshStl_init("./app/detectron2/");
	// ------------------------------------------------------
	// sout
	console.log('# originalname : ' + req.files[0].originalname);
	console.log('# destination : ' + req.files[0].destination);
	console.log();
	console.log('loaded : ');
	console.log(req.files[0]);
	console.log();
	// ------------------------------------------------------
	// ## OPERATION ##
	exec_detectron2(path.join(path.resolve(''), req.files[0].path));
	// ------------------------------------------------------
	// sout
	console.log('# RETURN : ' + path.parse(fname_png).name + '_Detectron2.zip');
	console.log();
	
	copyf("blockSpinner.png","./app/detectron2/blockSpinner.png");
	
	// if (fs.existsSync("./app/detectron2/obj-detects_InstanceSegmentation.png") == false) {
		// copyf("obj-detects_InstanceSegmentation.png","./app/detectron2/obj-detects_InstanceSegmentation.png");
	// }
	
	// if (fs.existsSync("./app/detectron2/obj-detects_PanopticSegmentation.png") == false) {
		// copyf("obj-detects_PanopticSegmentation.png","./app/detectron2/obj-detects_PanopticSegmentation.png");
	// }
	
	// if (fs.existsSync("./app/detectron2/obj-detects_Keypoints.png") == false) {
		// copyf("obj-detects_Keypoints.png","./app/detectron2/obj-detects_Keypoints.png");
	// }
	
	// if (fs.existsSync("./app/detectron2/obj-detects_Detection.png") == false) {
		// copyf("obj-detects_Detection.png","./app/detectron2/obj-detects_Detection.png");
	// }
	// ------------------------------------------------------
	next();
}

function procMain(req, res)
{
	let fname_png = path.basename(req.files[0].path)
	
	// https://qiita.com/watatakahashi/items/4b456971ae6dc3038569#%E6%96%B9%E6%B3%95%E3%81%9D%E3%81%AE2-header%E3%81%AB%E6%8C%87%E5%AE%9A
	res.set({
		'Content-Disposition': `attachment; filename=${encodeURIComponent(path.parse(fname_png).name  + '_Detectron2.zip')}`
	});
	
	let content;
	try {
		content = fs.readFileSync(path.join(path.resolve(''), '/app/detectron2', path.parse(fname_png).name  + '_Detectron2.zip'));
	} catch (err) {
		console.log('# Failed to load : ' + path.parse(fname_png).name  + '_Detectron2.zip');
		console.log('     content     : ' + content);
		console.log('                   ' + err);
	}
	
	res.status(200).send(content);
	
	// res.redirect('/');
}
router.post("/", upload.any(), procSub, procMain);
// -------------------------------------------------------------------------------------------
module.exports = router;
