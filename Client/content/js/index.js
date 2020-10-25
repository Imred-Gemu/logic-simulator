let lastModified = null;

function getLastModified()
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", "/last-modified");
    xmlHttp.send(null);
	xmlHttp.onreadystatechange = function()
	{
	    if (xmlHttp.readyState == 4)
    	{
    		if(!lastModified)
    		{
    			lastModified = xmlHttp.responseText;
    		}
    		else if(lastModified != xmlHttp.responseText)
    		{
    			window.location.reload();
    		}
    	}
	}
}

setInterval(getLastModified, 1000);

WebAssembly.instantiateStreaming(fetch('myModule.wasm'), importObject)
.then(obj => {
  // Call an exported function:
  obj.instance.exports.exported_func();

  // or access the buffer contents of an exported memory:
  var i32 = new Uint32Array(obj.instance.exports.memory.buffer);

  // or access the elements of an exported table:
  var table = obj.instance.exports.table;
  console.log(table.get(0)());
})