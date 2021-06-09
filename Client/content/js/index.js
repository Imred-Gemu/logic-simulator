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

_simulate()
console.log(_test(0).toString(2))
