var special_cooldown = 0;
var special_active_duration = 0;
var current_time = 0;

$(document).ready(function() {
	setTimeout(function() {
		$("#logo").fadeOut(1000);
	}, 5000);

	// Debug
	// updatePostTimeResults([
	// 	{ name: "DarkWanderer", pumpkins: 18, lollipops: 2, goggles: 1, objective_medal: 'gold', survival_medal: 'gold', evader_medal: 'silver', score: 3850, distance_traveled: 2450, status: 'escaped' },
	// 	{ name: "SpookyGhost", pumpkins: 12, lollipops: 1, goggles: 0, objective_medal: 'silver', survival_medal: 'gold', evader_medal: 'bronze', score: 2900, distance_traveled: 1890, status: 'escaped' },
	// 	{ name: "NightHunter", pumpkins: 8, lollipops: 0, goggles: 1, objective_medal: 'bronze', survival_medal: 'silver', evader_medal: 'gold', score: 2650, distance_traveled: 1560, status: 'alive' },
	// 	{ name: "ShadowRunner", pumpkins: 15, lollipops: 1, goggles: 0, objective_medal: 'gold', survival_medal: 'none', evader_medal: 'bronze', score: 2100, distance_traveled: 2100, status: 'dead' },
	// 	{ name: "MoonWalker", pumpkins: 6, lollipops: 2, goggles: 0, objective_medal: 'bronze', survival_medal: 'silver', evader_medal: 'none', score: 1850, distance_traveled: 980, status: 'alive' },
	// 	// { name: "PhantomStrider", pumpkins: 4, lollipops: 0, goggles: 0, objective_medal: 'bronze', survival_medal: 'bronze', evader_medal: 'silver', score: 1600, distance_traveled: 1420, status: 'alive' },
	// 	// { name: "GrimReaper99", pumpkins: 10, lollipops: 1, goggles: 1, objective_medal: 'silver', survival_medal: 'none', evader_medal: 'none', score: 1450, distance_traveled: 1750, status: 'dead' },
	// 	// { name: "HauntedSoul", pumpkins: 2, lollipops: 0, goggles: 0, objective_medal: 'none', survival_medal: 'bronze', evader_medal: 'bronze', score: 950, distance_traveled: 670, status: 'alive' },
	// 	// { name: "CrypticNinja", pumpkins: 5, lollipops: 1, goggles: 0, objective_medal: 'bronze', survival_medal: 'none', evader_medal: 'none', score: 850, distance_traveled: 1120, status: 'dead' },
	// 	// { name: "SilentScream", pumpkins: 7, lollipops: 0, goggles: 0, objective_medal: 'bronze', survival_medal: 'bronze', evader_medal: 'none', score: 820, distance_traveled: 890, status: 'alive' },
	// 	// { name: "TwilightSeeker", pumpkins: 3, lollipops: 0, goggles: 1, objective_medal: 'bronze', survival_medal: 'silver', evader_medal: 'none', score: 750, distance_traveled: 540, status: 'alive' },
	// 	// { name: "VoidWalker", pumpkins: 1, lollipops: 0, goggles: 0, objective_medal: 'none', survival_medal: 'none', evader_medal: 'bronze', score: 520, distance_traveled: 780, status: 'dead' },
	// 	// { name: "EchoRaven", pumpkins: 9, lollipops: 0, goggles: 0, objective_medal: 'silver', survival_medal: 'none', evader_medal: 'none', score: 500, distance_traveled: 1340, status: 'dead' },
	// 	// { name: "MysticRunner", pumpkins: 0, lollipops: 0, goggles: 0, objective_medal: 'none', survival_medal: 'bronze', evader_medal: 'none', score: 200, distance_traveled: 320, status: 'alive' },
	// 	// { name: "BloodMoon", pumpkins: 0, lollipops: 0, goggles: 0, objective_medal: 'none', survival_medal: 'none', evader_medal: 'none', score: 50, distance_traveled: 150, status: 'dead' }
	// ], [
	// 	{ name: "HeadlessHorror", kills: 8, damage_dealt: 920, devout_medal: 'gold', brutality_medal: 'gold', chaser_medal: 'silver', score: 5960, distance_traveled: 3200 },
	// 	{ name: "DarkKnight666", kills: 6, damage_dealt: 780, devout_medal: 'silver', brutality_medal: 'silver', chaser_medal: 'gold', score: 4680, distance_traveled: 2850 },
	// 	// { name: "IronExecutioner", kills: 5, damage_dealt: 650, devout_medal: 'silver', brutality_medal: 'silver', chaser_medal: 'bronze', score: 3750, distance_traveled: 2400 },
	// 	// { name: "SavageButcher", kills: 4, damage_dealt: 520, devout_medal: 'bronze', brutality_medal: 'bronze', chaser_medal: 'bronze', score: 2860, distance_traveled: 1980 },
	// 	// { name: "BrutalSlayer", kills: 3, damage_dealt: 380, devout_medal: 'bronze', brutality_medal: 'bronze', chaser_medal: 'none', score: 2190, distance_traveled: 1650 },
	// 	// { name: "ChaosReaper", kills: 2, damage_dealt: 240, devout_medal: 'bronze', brutality_medal: 'bronze', chaser_medal: 'none', score: 1620, distance_traveled: 1320 },
	// 	// { name: "ViciousHunter", kills: 1, damage_dealt: 120, devout_medal: 'bronze', brutality_medal: 'bronze', chaser_medal: 'none', score: 1100, distance_traveled: 890 }
	// ]);
});

setInterval(function() {
	if (current_time > 0) {
		current_time--;

		let mins = ("00" + Math.floor(current_time / 60)).slice(-2);
		let seconds = ("00" + (current_time % 60)).slice(-2);

		$("#clock").html(mins.toString() + ":" + seconds.toString());
	}

	if (special_cooldown > 0) {
		special_cooldown--;

		if (special_cooldown == 0) {
			$("#special").addClass("ready");
		} else {
			$("#special_cooldown").html(special_cooldown);
		}
	}

	if (special_active_duration > 0) {
		special_active_duration--;

		if (special_active_duration == 0) {
			$("#special_active").removeClass("enabled");
		} else {
			$("#special_active_remaining_time").html(special_active_duration);
		}
	}
}, 1000);


function createTallyPlayerName(name) {
	const span = document.createElement("span");
	span.textContent = name == null ? "Unknown" : name;
	span.classList.add("tally_player_name");
	return span.outerHTML;
}

function createKnightHTML(knight) {
	// Create items HTML (kills)
	let itemsHTML = '';
	for (let i = 0; i < (knight.kills || 0); i++) {
		itemsHTML += '<span class="tally_player_skull"></span>';
	}

	return `
		<span class="tally_player">
			<span class="tally_player_left">
				${createTallyPlayerName(knight.name)}
				<span class="tally_player_items">
					${itemsHTML}
				</span>
			</span>
			<span class="tally_player_damage">${knight.damage_dealt || 0}</span>
			<span class="tally_player_distance">${knight.distance_traveled || 0}m</span>
			<span class="tally_player_score">${knight.score || 0}</span>
			<span class="tally_player_medals">
				${getMedalHTML(knight.devout_medal)}
				${getMedalHTML(knight.brutality_medal)}
				${getMedalHTML(knight.chaser_medal)}
			</span>
		</span>
	`;
}

function getMedalHTML(medalType) {
	switch (medalType) {
		case 'gold':
			return '<span class="tally_player_medal_gold"></span>';
		case 'silver':
			return '<span class="tally_player_medal_silver"></span>';
		case 'bronze':
			return '<span class="tally_player_medal_bronze"></span>';
		default:
			return '<span class="tally_player_medal_none"></span>';
	}
}

function createSurvivorHTML(survivor) {
	// Create items HTML (pumpkins and lollipops)
	let itemsHTML = '';

	// Add pumpkins
	for (let i = 0; i < (survivor.pumpkins || 0); i++) {
		itemsHTML += '<span class="tally_player_pumpkin"></span>';
	}

	// Add lollipops
	for (let i = 0; i < (survivor.lollipops || 0); i++) {
		itemsHTML += '<span class="tally_player_lollipop"></span>';
	}

	// Add goggles
	for (let i = 0; i < (survivor.goggles || 0); i++) {
		itemsHTML += '<span class="tally_player_binoculars"></span>';
	}

	// Determine status class
	let statusClass = 'tally_player_status_alive'; // default
	if (survivor.status === 'dead') {
		statusClass = 'tally_player_status_dead';
	} else if (survivor.status === 'escaped') {
		statusClass = 'tally_player_status_escaped';
	}

	return `
		<span class="tally_player">
			<span class="tally_player_left">
				${createTallyPlayerName(survivor.name)}
				<span class="tally_player_items">
					${itemsHTML}
				</span>
			</span>
			<span class="tally_player_status ${statusClass}"></span>
			<span class="tally_player_distance">${survivor.distance_traveled || 0}m</span>
			<span class="tally_player_score">${survivor.score || 0}</span>
			<span class="tally_player_medals">
				${getMedalHTML(survivor.objective_medal)}
				${getMedalHTML(survivor.survival_medal)}
				${getMedalHTML(survivor.evader_medal)}
			</span>
		</span>
	`;
}

function updatePostTimeResults(survivors, knights) {
	// Sort tables by score descending
	if (survivors && survivors.length > 0) {
		survivors.sort((a, b) => (b.score || 0) - (a.score || 0));
	}
	if (knights && knights.length > 0) {
		knights.sort((a, b) => (b.score || 0) - (a.score || 0));
	}

	// Build survivors HTML
	let survivorsHTML = '';
	if (survivors && survivors.length > 0) {
		survivors.forEach(survivor => {
			// TODO append directly
			survivorsHTML += createSurvivorHTML(survivor);
		});
	}

	// Build knights HTML
	let knightsHTML = '';
	if (knights && knights.length > 0) {
		knights.forEach(knight => {
			knightsHTML += createKnightHTML(knight);
		});
	}

	// Update the DOM
	document.getElementById('tally_survivors_list').innerHTML = survivorsHTML;
	document.getElementById('tally_knights_list').innerHTML = knightsHTML;

	$("#tally").addClass("enabled");
}

Events.Subscribe("UpdatePostTimeResults", updatePostTimeResults);

Events.Subscribe("AddSurvivor", function() {
	$("#survivor_heads").append($('<span class="head survivor_head_alive">'));
});

Events.Subscribe("KillSurvivor", function() {
	$(".survivor_head_alive").first().remove();
	$("#survivor_heads").prepend($('<span class="head survivor_head_dead">'));
});

Events.Subscribe("EscapeSurvivor", function() {
	$(".survivor_head_alive").first().remove();
	$("#survivor_heads").prepend($('<span class="head survivor_head_escaped">'));
});

Events.Subscribe("AddKnight", function() {
	$("#knight_heads").append($('<span class="head knight_head_alive">'));
});

Events.Subscribe("KillKnight", function() {
	$(".knight_head_alive").first().remove();
	$("#knight_heads").prepend($('<span class="head knight_head_dead">'));
});

Events.Subscribe("SetLabel", function(label) {
	if (label == "") {
		$("#top_bar_label").hide();
		$("#top_bar_pumpkins_remaining").css("display", "flex");
	} else {
		$("#top_bar_pumpkins_remaining").hide();
		$("#top_bar_label").html(label);
		$("#top_bar_label").show();
	}
});

Events.Subscribe("SetObjective", function(objective) {
	$("#objective").html(objective);
});

Events.Subscribe("SetMatchInProgress", function(in_progress) {
	if (in_progress) {
		$("body").removeClass("match_not_started");
	} else {
		$("body").addClass("match_not_started");
	}
});

Events.Subscribe("SetSpectating", function(is_spectating) {
	if (is_spectating) {
		$("body").addClass("spectating");
	} else {
		$("body").removeClass("spectating");
	}
});

Events.Subscribe("SetPostTime", function(is_post_time) {
	if (is_post_time) {
		$("body").addClass("post_time");
	} else {
		$("body").removeClass("post_time");
	}
});

Events.Subscribe("ClearHUD", function() {
	$("body").removeClass("knight");
	$("body").removeClass("survivor");
	$("body").removeClass("post_time");
	$("body").addClass("spectating");
	$("body").addClass("match_not_started");
	$("#knight_heads").html("");
	$("#survivor_heads").html("");
	$("#pumpkins_found_count").html("0");
	$("#label").html("");
	$("#tally_knights_list").html("");
	$("#tally_survivors_list").html("");
	$(".powerup_item").hide();
	$("#flashlight").addClass("enabled");
	$("#spotted").removeClass("enabled");
	$("#radar").removeClass("enabled");
	$("#special_active").removeClass("enabled");
	$("#tally").removeClass("enabled");

	$("#map").hide();
	$("#help").hide();
	$("#map_status").removeClass("enabled");
	$("#help_status").removeClass("enabled");

	current_time = 0;
	special_cooldown = 0;
	special_active_duration = 0;
});

Events.Subscribe("IAmKnight", function() {
	$("body").addClass("knight");
	$("body").removeClass("survivor");

	$("#radar_label").html("SURVIVOR NEARBY");
	$("#special_label").html("SPECIAL");
});

Events.Subscribe("SetKnightArchetype", function(archetype_name, ability_name) {
	$("#special_title").html(archetype_name);
	$("#special_label").html(ability_name);
	$("#special_active_label").html(ability_name + " ACTIVE");
});

Events.Subscribe("IAmSurvivor", function() {
	$("body").addClass("survivor");
	$("body").removeClass("knight");

	$("#radar_label").html("PUMPKIN NEARBY");
	$("#special_label").html("SCREAM");
	$("#special_title").html("SURVIVOR");
});

Events.Subscribe("ShowNameTag", function(enabled, player_name) {
	if (enabled) {
		$("#name_tag").show();
		$("#name_tag").html(player_name);
	} else {
		$("#name_tag").hide();
	}
});

Events.Subscribe("MapToggled", function(enabled) {
	if (enabled) {
		$("#map").show();
		$("#map_status").addClass("enabled");
	} else {
		$("#map").hide();
		$("#map_status").removeClass("enabled");
	}
});

Events.Subscribe("HelpToggled", function(enabled) {
	if (enabled) {
		$("#help").show();
		$("#help_status").addClass("enabled");
	} else {
		$("#help").hide();
		$("#help_status").removeClass("enabled");
	}
});

Events.Subscribe("FlashlightToggled", function(enabled) {
	if (enabled) {
		$("#flashlight").addClass("enabled");
	} else {
		$("#flashlight").removeClass("enabled");
	}
});

Events.Subscribe("SpottedToggled", function(enabled) {
	if (enabled) {
		$("#spotted").addClass("enabled");
	} else {
		$("#spotted").removeClass("enabled");
	}
});

Events.Subscribe("SetNightVision", function(enabled) {
	if (enabled) {
		$("#night_vision").show();
	} else {
		$("#night_vision").hide();
	}
});

Events.Subscribe("SetLollipop", function(enabled) {
	if (enabled) {
		$("#lollipop").show();
	} else {
		$("#lollipop").hide();
	}
});

Events.Subscribe("TriggerRadar", function() {
	$("#radar").addClass("enabled");

	setTimeout(function() {
		$("#radar").removeClass("enabled");
	}, 1000);
});

Events.Subscribe("SetSpecialCooldown", function(cooldown) {
	special_cooldown = cooldown;
	$("#special_cooldown").html(special_cooldown);
	$("#special").removeClass("ready");
});

Events.Subscribe("SetSpecialActive", function(remaining_time) {
	special_active_duration = remaining_time;

	if (remaining_time > 0) {
		$("#special_active_remaining_time").html(remaining_time);
		$("#special_active").addClass("enabled");
	} else {
		$("#special_active").removeClass("enabled");
	}
});

Events.Subscribe("SetClock", function(remaining_time) {
	current_time = remaining_time;
});

Events.Subscribe("UpdatePumpkinsFound", function(total_pumpkins, current_pumpkins) {
	$("#pumpkins_found_count").html(total_pumpkins - current_pumpkins);
});

Events.Subscribe("AddFeedItem", function(type, name1, name2) {
	let feedItem = null;

	if (type === "pumpkin") {
		feedItem = $('<div class="feed-item"><span class="feed-item-name">' + name1 + '</span> found a <span class="feed-item-image feed-item-pumpkin"></span></div>');
	} else if (type === "lollipop") {
		feedItem = $('<div class="feed-item"><span class="feed-item-name">' + name1 + '</span> found a <span class="feed-item-image feed-item-lollipop"></span></div>');
	} else if (type === "goggles") {
		feedItem = $('<div class="feed-item"><span class="feed-item-name">' + name1 + '</span> found a <span class="feed-item-image feed-item-goggles"></span></div>');
	} else if (type === "kill") {
		if (name2) {
			feedItem = $('<div class="feed-item"><span class="feed-item-name">' + name2 + '</span> killed <span class="feed-item-name">' + name1 + '</span><span class="feed-item-image feed-item-kill"></span></div>');
		} else {
			feedItem = $('<div class="feed-item"><span class="feed-item-name">' + name1 + '</span> died<span class="feed-item-image feed-item-kill"></span></div>');
		}
	} else if (type === "escaped") {
		feedItem = $('<div class="feed-item"><span class="feed-item-name">' + name1 + '</span> escaped alive<span class="feed-item-image feed-item-escaped"></span></div>');
	} else {
		feedItem = $('<div class="feed-item">' + name1 + '</div>');
	}

	$("#feed").append(feedItem);

	feedItem.delay(10000).fadeOut("normal", function() {
		$(this).remove();
	});
});

Events.Subscribe("UpdateMappedKeys", function(key_bindings) {
	document.querySelectorAll("[data-keybinding]").forEach(function(element) {
		var key = element.getAttribute("data-keybinding");
		if (key_bindings[key]) {
			element.setAttribute("src", key_bindings[key]);
		}
	});
});