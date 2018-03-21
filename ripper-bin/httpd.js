var express = require('express')
var fs = require('fs')
var serveStatic = require('serve-static')
var util = require('util')

// Constants.
// Serve from the current working directory.
const ROOT_DIR = "./"
const PORT = 8888

var app = express()

/*
 * Express.js middleware to list the contents of a directory.
 *  - req.path is the directory requested (document root = host's ROOT_DIR)
 *  - ?html=true to get you a more human-friendly version
 */
var listDirectory = function (req, res, next) {
  path = req.path
  if (! fs.existsSync(ROOT_DIR + path)) {
    res.status(404).send("404 not found").end()
    return
  }
  if (req.query.html) {
    res.type('text/html')
    res.send(renderHtmlFileList(path))
  } else {
    res.type('text/plain')
    res.send(renderPlainFileList(path))
  }
  next()
}

var renderPlainFileList = function(path) {
  listing = ""
  fs.readdirSync(ROOT_DIR + path).forEach(function(f) {
  	isDir = fs.statSync(ROOT_DIR + path + f).isDirectory() ? "/" : ""
  	listing += util.format("%s%s\n", f, isDir)
  })
  return listing
}

var renderHtmlFileList = function(path) {
  bodyTemplate =
    "<html><body style='font-family: monospace'><table>" +
    "<tr align=left><th>Modified</th><th>Bytes</th><th>Name</th></tr>%s" +
    "</table></body></html>"
  rowTemplate = "<tr><td>%s</td><td>%s</td><td><a href='%s?html=true'>%s%s</a></td></tr>"
  listing = ""
  fs.readdirSync('./' + path).forEach(function(f) {
  	stats = fs.statSync(ROOT_DIR + path + f)
  	modifiedTime = new Date(stats.mtime);
  	size = stats.size
  	isDir = stats.isDirectory() ? "/" : ""
  	listing += util.format(rowTemplate, modifiedTime, size, f, f, isDir)
  })
  return util.format(bodyTemplate, listing)
}

app.use(serveStatic(ROOT_DIR, {}))
app.use(listDirectory)
app.listen(PORT)
