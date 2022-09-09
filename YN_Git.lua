function _init()
	menu = 1
	gameover = false
	
	rest_wait = 0
	ng_wait = 0
	start_wait = 0
	sakura_wait = 0
	
	score = 0
	youkai = 0
	energy_lvl = 0
	
	--enem_count = 0

	x = 56
	y = 112
	spd = 2.0
	
	xb = x+4
	yb = y-10
	sbx = rnd({-1, 1})
	sby = -1
	
	--animation sprites
	plr_spr_1 = 3
	plr_spr_2 = 19
	
	ball_spr = 23 --0
	
	menu_x_spr = 68
	
	x_splcd_spr = 84
	
	-- animation wait	
	spell_x_wait = 0
	
	plr_anim_time = 0
	plr_anim_wait = .2
	
	ball_anim_time = 0
	ball_anim_wait = .05
	
	bricks = {}
	
	--spellcard
	spellcard_active = false
	add_balls = {}
	cntbl = 0
	
	create_lvl()
	
	partc={}
	plr_prtc={}
	
	shake = 0
	camera()
	
	main_music()
end

function main_music()
	music(10)
end

function start_music()
	music(-1, 550)
	music(2)
end

function gameover_music()
	music(-1, 500)
	music(0)
end

function _update60()
	updateparts()

	if (menu == 0 and
					gameover == false) then
					
		animate_plr()
		
		--playeraura(x, y+5)
				
		if(start_wait > 60) then
			if (btn(0)) then
				x -= spd
				if (x < 0) x = 0
			end
			
			if (btn(1)) then
				x += spd
				if (x > 112) x = 112
			end
				
			if cntbl == 0 then
				update_ball()
			elseif cntbl == 3 then
				xb = x+4
				yb = y-10
				sby = -1
			end
				
			new_enemy()
			
			update_spellcard()
			
		else
			--animate_cast()
			updatecast()
			castball(60, 102)
		end
		
		
		start_wait += 1

	elseif (gameover == true) then		
		
		if (rest_wait == 0) then
			gameover_music()
			rest_wait += 1
		end
		
		if (btn(5)) then
			
			rest_wait += 2
			
			start(rest_wait)	
			
			start_music()
		end
		
	elseif(menu == 1) then
		animate_x_btn()
		
		sakura_partc()
		
		rm_anim()
		
		if(btn(5)) menu = 2 
		
	elseif(menu == 2) then
		for _p in all(partc) do
			if (_p.tp == 3) del(partc, _p)
		end
	
		if ng_wait == 0 then
			start_music()
			
			ng_wait += 1
		end
	
		animate_x_btn()
	
		if(btn(5)) then 
			ng_wait +=1
		
			if (ng_wait > 6) menu = 0
		end
	end
end

function update_ball()
	animate_ball()

	xb += sbx
	yb += sby
	
	--particles
	spawntrail(xb, yb, 0)
	
	--wall check
	if (xb < 0) then
		xb = 0
		sbx = -sbx
	end
	
	if (xb > 120) then
		xb = 120
		sbx = -sbx
	end
	
	if (yb < 9) then
		yb = 9
		sby = -sby
	end
	
	if (yb > 128) then	
		shake += 0.2
	
		gameover = true
	end
	
	
	-- player check
 if (yb+4==y and xb+8>=x and xb<=x+16) then
		sby = -sby
		enemy_move()
		
		if (xb+8>=x and xb+8<=x+8) then
			if (sbx > 0) sbx = -sbx 
		end
		
		if (xb>=x+9 and xb<=x+16) then
			if (sbx < 0) sbx = -sbx
		end
		
 	sound()
	end
	
	
	-- enemy check
	foreach(bricks, brick_attacked)
	
	
end

function start(wait)
	if (wait > 5) then
		_init()
		
		menu = 0
	end
end

function enemy_move()
	for e in all(bricks) do
		e.y += 4
	end					
end

function new_enemy()
	if (count(bricks) == 0) then
		create_lvl()
	end	
end

function sound()
	sfx(1)
end

function animate_x_btn()
	if (time() - ball_anim_time > .2) then
		menu_x_spr += 1
		
		ball_anim_time = time()

		if (menu_x_spr > 69) then
			menu_x_spr = 68
		end
	end
end

function animate_plr()
	if (time() - plr_anim_time > plr_anim_wait) then
		plr_spr_1 += 2
		plr_spr_2 += 2
		
		plr_anim_time = time()

		if (plr_spr_1 > 5 and plr_spr_2 > 21) then
			plr_spr_1 = 3
			plr_spr_2 = 19
		end
	end
end

function animate_ball()
	if (time() - ball_anim_time > ball_anim_wait) then
		ball_spr += 1
		
		ball_anim_time = time()

		if (ball_spr > 26) then
			ball_spr = 23
		end
	end
end

function animate_cast()
	if (time() - ball_anim_time > .35) then
		ball_spr += 1
		
		ball_anim_time = time()

		if (ball_spr > 2) then
			ball_spr = 23
		end
	end
end

function _draw()
	shake_effect()

	if (menu == 1 and
					gameover == false) then
		cls()			
		
		draw_menu()
		drawparts()
				
	elseif (menu == 2) then
		cls()
	
		draw_dialog()
		
	else
		cls(1)
		
			
		draw_topbar()
	
		draw_bricks()
	
		draw_plr()	
		
		if (start_wait > 48 and
					cntbl == 0) then 
					
			draw_ball() 
		end
		
		drawparts()
		
		draw_spellcard()
	
		if (gameover == true) then 		
			draw_end()
		end
	end
end

function draw_topbar()
	rectfill(0,0, 128, 8, 8)
	line(0, 8, 128, 8, 7)
	
	print('score:'..score, 3, 2, 7)
	
	print('spell card', 52, 2, 7)
	draw_spell_bar()
	--print('youkai:'..youkai, 86, 2, 7)
end

function draw_menu()
	spr(64, 48, 36)
	spr(65, 56, 36)
	spr(80, 48, 44)
	spr(81, 56, 44)
	
	spr(66, 64, 36)
	spr(67, 72, 36)
	spr(82, 64, 44)
	spr(83, 72, 44)
	
	print('press    to start!', 28, 65, 6)
	spr(menu_x_spr, 52, 63)	
	
	
	rectfill(0, 100, 128, 128, 1)
	rm_draw()
	draw_back_menu()
end

function draw_back_menu()	
	local step = -3

	for by = 97, 81, step do
		line(0, by, 128, by, 1)
	end

	local spr_num = 128
	
	for my = 96, 122, 8 do
		for mx = 0, 122, 8 do
			spr(spr_num, mx, my)
			
			spr_num += 1
		end
	end
end

function draw_dialog()
	rectfill(0, 60, 128, 80, 8)
	rect(-1, 59, 129, 81, 7)
	
	print('"youkai night" is coming...', 3, 62, 7)
	print ('i need to be ready!', 3, 74, 7)

	spr(menu_x_spr, 60, 84)
	
	draw_reimu()
end

function draw_reimu()
	rm_spr = 11
	
	for ry = 20, 52, 8 do
		for rx = 88, 120, 8 do
			spr(rm_spr, rx, ry)
			
			rm_spr += 1
		end

		rm_spr += 11
	end
		
end

function draw_end()
	rectfill(0, 40, 128, 64, 8)
	rect(-1, 39, 129, 65, 7)
	
	print('your shrine was destroyed...', 8, 42, 7)
	print ('restart', 50, 54, 7)
	
	if (btn(5)) then
		rectfill(49, 53, 77, 59, 7)
		rectfill(48, 54, 78, 58, 7)
	
		print ('restart', 50, 54, 1)
	end
end

function draw_ball()
	spr(ball_spr, xb, yb)
end

function draw_plr()
	spr(plr_spr_1, x, y)
	spr(plr_spr_1+1, x+8, y)
	spr(plr_spr_2, x, y+8)
	spr(plr_spr_2+1, x+8, y+8)
end

function create_lvl()		
	--pattern = 2
	for y = 10, 68, 16 do	
		pattern = rnd({1, 2, 3})
	
		if (pattern == 1) then
			local xy = 16*(rnd({0,1,2,3}))
		
			pattern_line(4+xy, 116-xy, y)	
		end
	
		if (pattern == 2) then
			local xy = 16*rnd({0,1})
		
			pattern_mid_n_walls(36+xy, 84-xy, y)
		end
		
		if (pattern == 3) then
			local cnt = rnd({2,3})
			
			pattern_windows(cnt, y)
		end
	end
	
	enem_count = count(bricks)
end

function pattern_line(_begin, _end, _y)
	for x = _begin, _end, 16 do
		create_brick(x, _y)
	end
end

function pattern_walls(_y)
	create_brick(4, _y)
	create_brick(116, _y)
end

function pattern_mid_n_walls(_begin, _end, _y)
	pattern_walls(_y)
	
	pattern_line(_begin, _end, _y)
end

function pattern_windows(cnt, _y)
		if (cnt == 2) then
			for x = 4, 116, 48 do
				pattern_line(x, x+16, _y)
			end 
		else
			for x = 4, 116, 80 do
				pattern_line(x, x+32, _y)
			end
		end
end


function create_brick(x, y)
	local brick = {}
	brick.x = x
	brick.y = y	
	brick.spr = rnd({7,8,9,10})
	add (bricks, brick)
end

function draw_bricks()
	foreach(bricks, draw_brick)
end

function draw_brick(b)
	spr(b.spr, b.x, b.y)
end

function brick_attacked(b)
	local str_sh = 0.08
	local rng = 7.1

	if (abs(b.x-xb)<rng and 
					yb+1 == b.y+8) then
		youkai_death(b)
					
		shake += str_sh
					
		sby = -sby
		brick_crush(b)
		sfx(3)
		
		incrase_score()
	end
		
	if (abs(b.x-xb)<rng and 
	    yb+6 == b.y-1) then	 
	 youkai_death(b)
	 
	 shake += str_sh
	  
	 sby = -sby  
	 brick_crush(b)
	 sfx(3)

		incrase_score()
	end
		
	if (abs(b.y-yb)<rng and 
					xb+1 == b.x+8) then		
		youkai_death(b)
		
		shake += str_sh
					
		sbx = -sbx
		brick_crush(b)
		sfx(3)
		
		incrase_score()
	end
		
	if (abs(b.y-yb)<rng and 
					xb+6 == b.x-1) then	
		youkai_death(b)
		
		shake += str_sh
		
				sbx = -sbx				
		brick_crush(b)
		sfx(3)
		
		incrase_score()
	end
	
	if(b.y+6 >= 112) then 
		youkai_death(b)
		
		shake += str_sh
	
		gameover = true
	end
end

function incrase_score()
	score += 10*(enem_count - count(bricks))
	
	youkai += enem_count - count(bricks)
	
	enem_count = count(bricks)
	
	if (enem_count == 0) then
		score += 100
	end
end

function brick_crush(b)
	del(bricks, b)
end


--visual effects!

function addpartc(_x, _y, _dx, _dy, _type, _maxage)
	local _p = {}
	
	_p.x = _x+4
	_p.y = _y+4
	
	_p.dx = _dx
	_p.dy = _dy
	
	_p.tp = _type
	_p.mage = _maxage
	
	_p.age = 0
	
	add(partc, _p) 
end


function sakura_partc()
	local _r = rnd()
	local _ox = sin(_r)*5
	local _oy = cos(_r)*5
	
	local _dy = cos(_r)*0.2
	
	if sakura_wait > 6 then
		addpartc(64+_ox, 114+_oy, 0.3, _dy, 3, 130+rnd(30))
		
		sakura_wait = 1
	else
		sakura_wait += 1
	end
end


function spawntrail(_x, _y, _tp)
	local _r = rnd()
	local _ox = sin(_r)*1.2
	local _oy = cos(_r)*1.2 

	addpartc(_x+_ox, _y+_oy, 0, 0, _tp, 10+rnd(15))
end


function youkai_death(yk)
	for i = 0, 10 do
		local _r = rnd()
		local _dx = sin(_r)*2
		local _dy = cos(_r)*2
	
		addpartc(yk.x, yk.y, _dx, _dy, 2, 40)
	end
end


function updateparts()
	local _p

	for i = #partc, 1, -1 do
		_p = partc[i]
		
		_p.age += 1
		
		if _p.age > _p.mage then
			del(partc, partc[i])
		end
		
		--move partc
		local gravity = 0.1
		
		_p.x += _p.dx
		_p.y += _p.dy
		if (_p.tp == 2) _p.dy += gravity
	end
end

function updatecast()
	local _p

	for i = #partc, 1, -1 do
		_p = partc[i]
		
		if _p.tp == 0 then
			if _p.x-74+rnd(20) > 0 then
				_p.x -= 1
			else
				_p.x +=1
			end
			
			if _p.y-116+rnd(20) > 0 then
				_p.y -= 1
			else
				_p.y +=1
			end
		end
		
		if start_wait > 58 and _p.tp == 0 then
			del(partc, partc[i])
		end
	end
end

function drawparts()
	for i = 1, #partc do
		_p = partc[i]
		
		if _p.tp == 0 then
			pset(_p.x, _p.y, rnd({7, 8}))
		end
		
		if _p.tp  == 1 then
			pset(_p.x, _p.y, rnd({7, 12}))
		end
		
		if _p.tp  == 2 then
			pset(_p.x, _p.y, 7)
		end
		
		if _p.tp  == 3 then
			pset(_p.x, _p.y, rnd({2, 14}))
		end
	end
end


function castball(_x, _y)
	local _r = rnd()
	local _ox = sin(_r)*15
	local _oy = cos(_r)*15

	addpartc(_x+_ox, _y+_oy, 0, 0, 0, 10+rnd(15))
end


function playeraura(_x, _y)
	local _r = rnd()
	local _ox = sin(_r)*13 + rnd(10)
	local _oy = cos(_r)*13 + rnd(10)

	addpartc(_x+_ox, _y+_oy, 0, 0, 1, 10+rnd(15))
end

function shake_effect()
	local sx = 16-rnd(32)
	local sy = 16-rnd(32)
	
	sx = sx*shake
	sy = sy*shake
	
	camera(sx, sy)
	
	shake = shake*0.95
	if shake < 0.05 then
		shake = 0
	end	
end


-- spell card!

function update_spellcard()
	--energy level
	if youkai == 5 and
				energy_lvl <=3 and
				spellcard_active == false then
		youkai = 0		
		
		energy_lvl += 1
		
	elseif energy_lvl == 4 then
		spell_x_wait += 1
	
		if (btn(5)) then
			shake += 0.8
		
			sfx(0)
		
			spellcard_active = true
			
			energy_lvl = 0
		end
	end

	if(spellcard_active == true) use_spellcard()
end


function use_spellcard()
	if (cntbl < 3) then
		add_ball_cast()
		
		cntbl += 1
	end
	
	--wall check
	for adb in all(add_balls) do
		spawntrail(adb.x-3, adb.y-3, 1)
	
		adb.life += 1
	
		adb.x += adb.spdx
		adb.y += adb.spdy
		
		--wall check
		if (adb.x-3 < 0) then
			adb.x = 3
			adb.spdx = -adb.spdx
		end
		
		if (adb.x+3 > 128) then
			adb.x = 125
			adb.spdx = -adb.spdx
		end
		
		if (adb.y-3 < 9) then
			adb.y = 12
			adb.spdy = -adb.spdy
		end
		
		if (adb.y+3 > 128) then
			adb.y = 125
			adb.spdy = -adb.spdy
		end
		
		--enemy check
		spellcard_attack(adb)
		
		if (adb.life > adb.maxlife) del(add_balls, adb)
	end
		
	if (count(add_balls) == 0) then
	 spellcard_active = false
		cntbl = 0	
		youkai = 0
	end
end

function spellcard_attack(adbl)
	local yk

	for yk in all(bricks) do	
		local rng = 11
	
		if (adbl.y-3 == yk.y+8 and
						abs(yk.x - adbl.x) < rng) then
			youkai_death(yk)
			
			shake += 0.01
			
			adbl.spdy = -adbl.spdy
			brick_crush(yk)
			sfx(3)
			
			incrase_score()
		end
			
		if (adbl.y+3 == yk.y-1 and		
						abs(yk.x - adbl.x) < rng) then
			youkai_death(yk)
			
			shake = 0.01
			
			adbl.spdy = -adbl.spdy
			brick_crush(yk)
			sfx(3)
		
			incrase_score()
		end
			
		if (adbl.x-3 == yk.x+8 and
						abs(yk.y - adbl.y) < rng) then
			youkai_death(yk)
			
			shake = 0.01

			
			adbl.spdx = -adbl.spdx
			brick_crush(yk)
			sfx(3)
			
			incrase_score()
		end
			
		if (adbl.x+3 == yk.x and
						abs(yk.y - adbl.y) < rng) then
			youkai_death(yk)
			
			shake = 0.1
			
			adbl.spdx = -adbl.spdx
			brick_crush(yk)
			sfx(3)
			
			incrase_score()
		end
	end
end


function add_ball_cast()
	local addbl = {}
	addbl.x = xb+4
	addbl.y = yb+4
	
	addbl.spdx = rnd({- 2, 2})
	addbl.spdy = rnd({- 2, 2})
	
	addbl.life = 0
	addbl.maxlife = 240 + rnd(120)
	
	add(add_balls, addbl)
end

function draw_spellcard()
	foreach(add_balls, draw_add_ball)
end

function draw_add_ball(adb)
	circfill(adb.x, adb.y, 3, 12)
	circ(adb.x, adb.y, 3, 7)
end

function draw_spell_bar()
	--draw energy level
	local energy = 8*energy_lvl 

	--draw energy bar
	if energy_lvl < 4 then
		rectfill(93, 3, 93+energy, 5, 12)
	
		for x = 93, 125, 8 do
			line(x, 2, x, 6, 7)
		end
		
		if energy_lvl > 0 then
				for _x = 93, 92+energy, 8 do
					pset(_x+6, 3, 7)
					pset(_x+5, 4, 7)
					line(_x+1, 5, _x+7, 5, 5)
					line(_x+1, 3, _x+1, 5, 5)
				end
		end
	
		rect(93, 2, 125, 6, 7)
		
	elseif energy_lvl == 4 then	
		if spell_x_wait < 30 then
			spr(84, 96, 0)
			
		elseif spell_x_wait >= 30 and
									spell_x_wait < 60 then
			spr(85, 96, 0)
			
		elseif spell_x_wait >= 60 then
			spell_x_wait = 0
		end
	end	
end


--animation

rm_anim_wait = 0

rm_x = 26
rm_y1 = 123
rm_y2 = 124

rm_anim_step = -1

function rm_anim()
	if rm_anim_wait < 30 then
		if (rm_anim_wait == 15) then
			
			if rm_y1 > 122 then
				rm_y1 -= 1
			elseif (rm_y1 == 122) then
				rm_y1 += 1		
			end 
		
		end
		
		if (rm_anim_wait == 20 or
						rm_anim_wait == 29) then
			rm_y2 += rm_anim_step
		end		
		
		rm_anim_wait += 1
	elseif(rm_anim_wait == 30) then
		rm_anim_wait = 0
		rm_anim_step = -rm_anim_step
	end
end

function rm_draw()
	line(rm_x, rm_y1, rm_x, rm_y1+2, 5)
	line(rm_x+1, rm_y2, rm_x+1, rm_y2+1, 5)
end




