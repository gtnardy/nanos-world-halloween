var special_cooldown = 0;
var current_time = 0;

$(document).ready(function() {
	$("#special").hide();
	$("#radar_inner").hide();

	setTimeout(function() {
		$("#logo").fadeOut(1000);
	}, 5000);
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

		if (special_cooldown == 0)
		{
			$("#special").addClass("ready");
			$("#special_cooldown").html("READY");
		}
		else
		{
			$("#special_cooldown").html(special_cooldown);
		}
	}
}, 1000);

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
	$("#label").html(label);
});

Events.Subscribe("SetLabelBig", function(label, player_mvp, player_most_damage, player_most_pumpkins) {
	$("#label_big").html(label);

	$("#mvp").show();
	$("#mvp_pumpkins_value").html(player_most_pumpkins);
	$("#mvp_damage_value").html(player_most_damage);
	$("#mvp_value").html(player_mvp);
});

Events.Subscribe("ClearHUD", function() {
	$("#knight_heads").html("");
	$("#survivor_heads").html("");
	$("#special").hide();
	$("#pumpkins_found_count").html("0 / 0");
	$("#label").html("");
	$("#mvp").hide();
	$("#label_big").html("");
	$("#radar_inner").hide();

	current_time = 0;
	special_cooldown = 0;
});

Events.Subscribe("IAmKnight", function() {
	$("#special").show();
	
	$("#radar").removeClass("survivor");
	$("#radar").addClass("knight");

	$("#horseman_paper").show().delay(30000).fadeOut();
});

Events.Subscribe("IAmSurvivor", function() {
	$("#special").css("display", "none");

	$("#radar").removeClass("knight");
	$("#radar").addClass("survivor");

	$("#survivor_paper").show().delay(30000).fadeOut();
});

Events.Subscribe("MapToggled", function(enabled) {
	if (enabled)
	{
		$("#map").show();
		$("#map_status").addClass("enabled");
	}
	else
	{
		$("#map").hide();
		$("#map_status").removeClass("enabled");
	}
});

Events.Subscribe("FlashlightToggled", function(enabled) {
	if (enabled)
		$("#flashlight").addClass("enabled");
	else
		$("#flashlight").removeClass("enabled");
});

Events.Subscribe("TriggerRadar", function() {
	$("#radar_inner").show().delay(1000).fadeOut(1000);
});

Events.Subscribe("SetSpecialCooldown", function(cooldown) {
	special_cooldown = cooldown;
	$("#special_cooldown").html(special_cooldown);
	$("#special").removeClass("ready");
});

Events.Subscribe("SetClock", function(remaining_time) {
	current_time = remaining_time;
});

Events.Subscribe("UpdatePumpkinsFound", function(total_pumpkins, current_pumpkins) {
	$("#pumpkins_found_count").html(current_pumpkins + " / " + total_pumpkins);
});