/**
 * (c) Cotrino, 2012 (http://www.cotrino.com/)
 * 
 */

var cricleColor_1 = [
	'#faddd2', '#e1dbae', '#e8b1d1', '#de9f86', '#a0a3cb', '#84f18c', '#bfe09f', '#b5a5c0', '#accb8f', '#a1b2b2', '#b7acc7', 
	'#85e982', '#bedeef', '#e481ee', '#da98ac', '#83a2c2', '#d8b1ea', '#f1b39f', '#94deb2', '#cfeb8a', '#9da096', '#bcdeb4', 
	'#fadd9c', '#99cb8a', '#d1b897', '#8fef82', '#cdd8a7', '#b7aa80', '#efdeeb', '#addee1', '#a6cd8a', '#94f9b4', '#caa691', 
	'#9c89c3', '#c0eefa', '#e4b8d3', '#f7b198', '#a3eef9', '#a7caf7', '#a28eee', '#e98389', '#a6da8b', '#dcd0d4', '#aea3b2', 
	'#ca8dad', '#98fc93', '#c9a390', '#8ea1c3', '#81dcdf', '#c7fa8b', '#e4c7fc', '#f0d4f1', '#9ee5c8', '#86fbc8', '#d9dee7', 
	'#97d1ab', '#def7a4', '#d1a2f2', '#94dab5', '#8f80f7', '#dcc9a7', '#caabb1', '#9dc7ef', '#9dbbef', '#d2a0c2', '#d4bc97', 
	'#e3b5a3', '#efcdc3', '#f79283', '#bfaada', '#bbf191', '#d68c9e', '#b7c7f7', '#e6de95', '#c7d9f7', '#bfaac1', '#e3b3b0', 
	'#acb1df', '#c6dd8f', '#b8a0ec', '#c9cdec', '#f7d580', '#abe4e4', '#c7bfb1', '#86dcb1', '#a7f4bb', '#d2849e', '#d28bd7', 
	'#ec8e97', '#a9cc96', '#96f0d1', '#ebc3d4', '#a291d1', '#adab86', '#b388ac', '#92cddb'
];

var textColor_1 = [
	'#ba9d92','#a19b6e','#a87191','#9e5f46','#60638b','#44b14c','#7fa05f','#756580','#6c8b4f','#617272','#776c87',
	'#45a942','#7e9eaf','#a441ae','#9a586c','#436282','#9871aa','#b1735f','#549e72','#8fab4a','#5d6056','#7c9e74',
	'#ba9d5c','#598b4a','#917857','#4faf42','#8d9867','#776a40','#af9eab','#6d9ea1','#668d4a','#54b974','#8a6651',
	'#5c4983','#80aeba','#a47893','#b77158','#63aeb9','#678ab7','#624eae','#a94349','#669a4b','#9c9094','#6e6372',
	'#8a4d6d','#58bc53','#896350','#4e6183','#419c9f','#87ba4b','#a487bc','#b094b1','#5ea588','#46bb88','#999ea7',
	'#57916b','#9eb764','#9162b2','#549a75','#4f40b7','#9c8967','#8a6b71','#5d87af','#5d7baf','#926082','#947c57',
	'#a37563','#af8d83','#b75243','#7f6a9a','#7bb151','#964c5e','#7787b7','#a69e55','#8799b7','#7f6a81','#a37370',
	'#6c719f','#869d4f','#7860ac','#898dac','#b79540','#6ba4a4','#877f71','#469c71','#67b47b','#92445e','#924b97',
	'#ac4e57','#698c56','#56b091','#ab8394','#625191','#6d6b46','#73486c','#528d9b'
];

var cricleColor_2 = [
	 "#cc0000", "#006600", "#330000", "#ff0000", "#9900ff", "#993366", "#66cc66", "#0033cc", "#006666", "#990066",
     "#663300", "#660000", "#ff0000", "#ff3300", "#ff6600", "#ff9900", "#ffcc00", "#ffff00", "#3300ff", "#3333ff", 
     "#3366ff", "#3399ff", "#33ccff", "#33ffff", "#66ffff", "#66ccff", "#6699ff", "#6666ff", "#6633ff", "#6600ff", 
     "#330000", "#333300", "#336600", "#339900", "#33cc00", "#33ff00", "#66ff00", "#66cc00", "#669900", "#666600", 
     "#ff00ff"
];


var w = 0, h = 0;
var chart = "network";
var networkChart = {
		vis : null,
		nodes : [],
		labelAnchors : [],
		labelAnchorLinks : [],
		links : [],
		force : null,
		force2 : null
};

var hideUnrelated = false;
var similarityThresholdMin = 100;
var similarityThresholdMax = 0;
var similarityThreshold = 0.001;

function getCriColor(idx){
	var isColor1 = $('input[name=choose_color]:checked').val();
	if(isColor1 == '1'){
		if(cricleColor_1.length > idx) return cricleColor_1[idx];
		else return cricleColor_1[idx%cricleColor_1.length]
	}else{
		if(cricleColor_2.length > idx) return cricleColor_2[idx];
		else return cricleColor_2[idx%cricleColor_2.length]
	}
	
}

function getTxtColor(idx){
	var isColor1 = $('input[name=choose_color]:checked').val();
	if(isColor1 == '1'){
		if(textColor_1.length > idx) return textColor_1[idx];
		else return textColor_1[idx%cricleColor_1.length]
	}else{
		if(cricleColor_2.length > idx) return cricleColor_2[idx];
		else return cricleColor_2[idx%cricleColor_2.length]
	}
}

function restart() {

	nodesArray = [];
	nodesHash = [];
	for(var a=0; a<colNm_all.length; a++){
		nodesArray.push({ label : colNm_all[a], id : a, color : getCriColor(a), textcolor : getTxtColor(a), size : circle_size[a]});
		nodesHash[colNm_all[a]] = a;
	}

	var lineColor = "#cfcfff";
	linksArray = [];
	//for(var a=0; a<colNm_all.length; a++){
	//	for(var b=0; b<colNm_all.length; b++){
	//		if(a == b) continue;
	//		linksArray.push({ desc : colNm_all[a]+" -- "+colNm_all[b], source : a, target : b, weight : Math.abs(result_val_all[a*colNm_all.length+b]), color : lineColor });
	//	}
	//}
	

	for(var a=0; a<pf_val.length; a++){
		for(var b=0; b<colNm_all.length; b++){
			if(pf_val[a].source == colNm_all[b]){ pf_val[a].s_idx = b; }
			if(pf_val[a].target == colNm_all[b]) pf_val[a].t_idx = b;
		}
		linksArray.push({ desc : pf_val[a].source+" -- "+pf_val[a].target, source : pf_val[a].s_idx, target : pf_val[a].t_idx, weight : Math.abs(pf_val[a].weight), color : lineColor });
	}
	
	
	
	//hideUnrelated = $('#hide_checkbox').is(':checked');

	d3.select("#graph").remove();
	
	w = $('#networkDiv').width();
	h = $('#networkDiv').height();

	//similarityThreshold = Number($('#similarity').val()*100);

	// clear network, if available
	if( networkChart.force != null ) {	networkChart.force.stop();	}
	if( networkChart.force2 != null ) {	networkChart.force2.stop();	}
	networkChart.nodes = [];
	networkChart.labelAnchors = [];
	networkChart.labelAnchorLinks = [];
	networkChart.links = [];

	drawNetwork();
}

function drawNetwork() {

	buildNetwork();

	networkChart.vis = d3.select("#networkDiv").append("svg:svg").attr("id", "graph").attr("width", w).attr("height", h);

	var link_distance = $("#link_distance").val();
	if(!Number(link_distance)) link_distance = 5;
	
	if(link_distance < 5) link_distance = 5; 
	
	networkChart.force = d3.layout.force().size([w, h])
	.nodes(networkChart.nodes).links(networkChart.links)
	//.gravity(2).linkDistance(link_distance).charge(-3000)
	.gravity(1).linkDistance(link_distance).charge(-1300)
	.linkStrength(function(x) {
		return x.weight * 10
	});
	networkChart.force.start();

	// brings everything towards the center of the screen
	networkChart.force2 = d3.layout.force()
	.nodes(networkChart.labelAnchors).links(networkChart.labelAnchorLinks)
	.gravity(0).linkDistance(0).linkStrength(8).charge(-link_distance).size([w, h]);
	networkChart.force2.start();

	var link = networkChart.vis.selectAll("line.link")
	.data(networkChart.links).enter()
	.append("svg:line").attr("class", "link")
	.style("stroke", function(d, i) { return d.color });

	var node = networkChart.vis.selectAll("g.node")
	.data(networkChart.force.nodes()).enter()
	.append("svg:g").attr("id", function(d, i) { return d.label }).attr("class", "node");
	node.append("svg:circle").attr("id",function(d, i) { return "c_"+d.label })
	.attr("r", function(d, i) { return d.size })
	.style("fill", function(d, i) { return d.color })
	.style("stroke", "#FFF").style("stroke-width", 2);
	node.call(networkChart.force.drag);
	//node.on("mouseover", function(d) {
	//	showInformation(d.label);
	//});

	var anchorLink = networkChart.vis.selectAll("line.anchorLink")
	.data(networkChart.labelAnchorLinks);

	var anchorNode = networkChart.vis.selectAll("g.anchorNode")
	.data(networkChart.force2.nodes()).enter()
	.append("svg:g").attr("class", "anchorNode");
	anchorNode.append("svg:circle")
	.attr("id",function(d, i) { return "ct_"+d.node.label })
	.attr("r", 0).style("fill", "#FFF");
	anchorNode.append("svg:text")
	.attr("id",function(d, i) { return "t_"+d.node.label })
	.text(function(d, i) {
		return i % 2 == 0 ? "" : d.node.label
	})
	.style("fill", function(d, i) { return d.node.textcolor })
	.style("font-family", "Arial")
	.style("font-size", 10);
	//.on("mouseover", function(d) {
	//	showInformation(d.node.label);
	//});

	var updateLink = function() {
		this.attr("x1", function(d) {
			return d.source.x;
		}).attr("y1", function(d) {
			return d.source.y;
		}).attr("x2", function(d) {
			return d.target.x;
		}).attr("y2", function(d) {
			return d.target.y;
		});

	}

	var updateNode = function() {
		this.attr("transform", function(d) {
			return "translate(" + d.x + "," + d.y + ")";
		});

	}

	node.on("mousedown", function(){
		networkChart.force.start();
		networkChart.force2.start();
	});
	node.on("mouseup", function(){
		networkChart.force.stop();
		networkChart.force2.stop();
	});
	
	networkChart.force.on("tick", function() {
		networkChart.force2.start();
		node.call(updateNode);
		
		anchorNode.each(function(d, i) {
			if(i % 2 == 0) {
				d.x = d.node.x;
				d.y = d.node.y;
			} else {
				var b = this.childNodes[1].getBBox();
				var diffX = d.x - d.node.x;
				var diffY = d.y - d.node.y;
				var dist = Math.sqrt(diffX * diffX + diffY * diffY);
				var shiftX = b.width * (diffX - dist) / (dist * 2);
				shiftX = Math.max(-b.width, Math.min(0, shiftX));
				var shiftY = 5;
				this.childNodes[1].setAttribute("transform", "translate(" + shiftX + "," + shiftY + ")");
			}
		});
		anchorNode.call(updateNode);
		link.call(updateLink);
		anchorLink.call(updateLink);
	});

}

function buildNetwork() {

	var newMapping = [];
	var k = 0;
	
	for(var i=0; i<nodesArray.length; i++) {
		nodesArray[i].maxWeight = null
		nodesArray[i].maxWeightTarget = null;
		nodesArray[i].isdraw = false;
		
		var node = nodesArray[i];
		var draw = true;

		if( hideUnrelated ) {
			if( getAmountLinks(i) == 0 ) {
				draw = false;
			}
			if( draw ) {
				newMapping[i] = k;
				networkChart.nodes.push(node);
				networkChart.labelAnchors.push({ node : node });
				networkChart.labelAnchors.push({ node : node	});
				k++;
			} else {
				newMapping[i] = -1;
			}
		}else{
			newMapping[i] = k;
			networkChart.nodes.push(node);
			networkChart.labelAnchors.push({ node : node });
			networkChart.labelAnchors.push({ node : node	});
			k++;
		}
		
	}
	
	for(var j=0; j<linksArray.length; j++) {
		var link = linksArray[j];
		var sim = link.weight;
		adjustSlider(sim);

		// just draw the links if similarity is higher than the threshold
		// or the nodes exist
		if( sim >= similarityThreshold/100.0 && newMapping[link.source] != -1 && newMapping[link.target] != -1 ) {
			var newLink = { source : newMapping[link.source], target : newMapping[link.target], weight : sim, color : link.color };
			networkChart.links.push(newLink);
			nodesArray[link.source].isdraw = true;
		}

		if(nodesArray[link.source].maxWeight == null || nodesArray[link.source].maxWeight < sim){
			var newLink = { source : newMapping[link.source], target : newMapping[link.target], weight : sim, color : link.color };
			nodesArray[link.source].maxWeight = sim;
			nodesArray[link.source].maxWeightTarget = newLink;
		}
		
	}

	
	//hide unrelated가 아니면 최소 하나의 선을 그려준다. 
	if( !hideUnrelated ) {
		for(var a=0; a<nodesArray.length; a++) {
			if(!nodesArray[a].isdraw){
				var newLink = nodesArray[a].maxWeightTarget;
				if(newLink){
					networkChart.links.push(newLink);
				}
			}
		}
	}
	

	// link labels to circles
	for(var i = 0; i < networkChart.nodes.length; i++) {
		networkChart.labelAnchorLinks.push({ source : i * 2, target : i * 2 + 1, weight : 1 });
	}

}

//adjust the scala of the slider
function adjustSlider(sim) {
	if( sim*100 > similarityThresholdMax ) {
		similarityThresholdMax = sim*100; 
	} else if( sim*100 < similarityThresholdMin ) {
		similarityThresholdMin = sim*100;
	}
}


function hide() {
	if( $('#hide_checkbox').is(':checked') ) {
		hideUnrelated = true;
		restart();
	} else {
		hideUnrelated = false;
		restart();
	}
}

function filterChange(event, ui) {
	similarityThreshold = ui.value;
	restart();
}

function chartChange(value) {
	chart = value;
	restart();
}

function getAmountLinks(n) {
	var linksAmount = 0;
	for(var j=0; j<linksArray.length; j++) {
		var link = linksArray[j];
		if( (link.source == n || link.target == n) && link.weight >= similarityThreshold/100.0 ) {
			linksAmount ++;
		}
	}
	alert(linksAmount);
	return linksAmount;
}

function showInformation(language) {
	var url = "http://en.wikipedia.org/wiki/"+language+"_language";
	var n = nodesHash[language];
	$('#language_information').html(nodesArray[n].desc);
}

