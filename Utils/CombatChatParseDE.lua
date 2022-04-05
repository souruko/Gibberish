
function TrimArticles(name)
	name = string.gsub(name, "^[Dd]ie ", "");
	name = string.gsub(name, "^[Dd]em ", "");
	name = string.gsub(name, "^[Dd]er ", "");
	name = string.gsub(name, "^[Dd]en ", "");
	return name;
end

function ParseCombatChat(line)

	-- 1) Damage line ---
	
	local initiatorName,avoidAndCrit,skillName,targetNameAmountAndType = string.match(line,"^(.*) gelang ein (.*)Treffer mit \"(.*)\" gegen (.*)%.$");
	
	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		
		local avoidType =
			string.match(avoidAndCrit,"^teilweise geblockter") and 8 or
			string.match(avoidAndCrit,"^teilweise parierter") and 9 or
			string.match(avoidAndCrit,"^teilweise ausgewichener") and 10 or 1;
		local critType =
			string.match(avoidAndCrit,"kritischer $") and 2 or
			string.match(avoidAndCrit,"zerst\195\182rerischer $") and 3 or 1;
		
		local targetName,amount,dmgType,moralePower = string.match(targetNameAmountAndType, "^(.*) f\195\188r ([%d,]*) Punkte Schaden des Typs \"(.*)\" auf (.*)$");
		-- damage was absorbed
		if targetName == nil then
			targetName = TrimArticles(targetNameAmountAndType);
			amount = 0;
			dmgType = 13;
			moralePower = 3;
		-- some damage was dealt
		else
			targetName = TrimArticles(targetName);
			amount = string.gsub(amount,",","")+0;
			-- note there may be no damage type
			dmgType = 
				dmgType == "Allgemein" and 1 or
				dmgType == "Feuer" and 2 or
				dmgType == "Blitz" and 3 or
				dmgType == "Frost" and 4 or
				dmgType == "S\195\164ure" and 5 or
				dmgType == "Schatten" and 6 or
				dmgType == "Licht" and 7 or
				dmgType == "Beleriand" and 8 or
				dmgType == "Westernis" and 9 or
				dmgType == "Uralte Zwergenart" and 10 or
				dmgType == "Ork-Waffe" and 11 or
				dmgType == "Hass" and 12 or 13;
			moralePower = (moralePower == "Moral" and 1 or moralePower == "Kraft" and 2 or 3);
		end
		
		-- Currently ignores damage to power
		if (moralePower == 2) then return nil end
		
		-- Update
		return 1,initiatorName,targetName,skillName,amount,avoidType,critType,dmgType;
	end
	
	-- 2) Heal line --
	
	--     (note the distinction with which self heals are now handled)
	--     (note we consider the case of heals of zero magnitude, even though they presumably never occur)
	local initiatorName,crit,skillNameTargetNameAmountAndType = string.match(line,"^(.*) wandte \"(.*)Heilung\" mit (.*)%.$");

	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		local critType =
			crit == "kritische " and 2 or
			crit == "zerst\195\182rerische " and 3 or 1;
			
		local skillNameTargetNameAndAmount,ending = string.match(skillNameTargetNameAmountAndType,"^(.*) Punkte (.*) wiederherstellte$");
		moralePower = (ending == "Moral" and 1 or ending == "Kraft" and 2 or 3);
		
		skillName,targetName,amount = string.match(skillNameTargetNameAndAmount,"^\"(.*)\" auf (.*) an, was ([%d,]*)$");
		targetName = TrimArticles(targetName);
		amount = string.gsub(amount,",","")+0;
		
		-- Update
		return (moralePower == 2 and 4 or 3),initiatorName,targetName,skillName,amount,critType;
	end
	
	-- 2.2) Self Heal
	
	--		(note that the self heal line is totally differend in comparision to the normal heal line in the german client)
	
	local skillName, initiatorName, critType, amount, moralPower = string.match(line, "^(.*) verursacht bei (.*) \"(.*)Heilung\" und stellt ([%d,]*) Punkte (.*) wieder her%.");
	if(initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		amount = string.gsub(amount, ",", "")+0;
		moralPower = (moralPower == "Moral" and 1 or moralPower == "Kraft" and 2 or 3);
		critType = critType == "kritische " and 2 or
				   critType == "zerst\195\182rerische " and 3 or 1;
		
		return (moralPower == 2 and 4 or 3), initiatorName, initiatorName, skillName, amount, critType;
	end
	
	-- 3) Buff line --
	local initiatorName,skillName,targetName = string.match(line,"^(.*) wandte \"Vorteil\" mit \"(.*)\" auf (.*) an%.$");
	
	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		targetName = TrimArticles(targetName);
		-- Update
		return 17,initiatorName,targetName,skillName;
	end
	
	-- 4) Avoid line --

--FIND%
	-- standard avoid
	local initiatorName,targetName,skillName,erSie,avoidType = string.match(line,"^(.*) wollte (.*) mit (.*) treffen%, aber(.*)konterte den Versuch mit (.*).");
	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		targetName = TrimArticles(targetName);
		skillName = string.gsub(skillName, "\"", "");
		avoidType = string.gsub(avoidType, "\"", "");
		avoidType = 
				string.match(avoidType,"Blocken") and 5 or
				string.match(avoidType,"Parieren") and 6 or
				string.match(avoidType,"Ausweichen") and 7 or
				string.match(avoidType,"Widerstehen") and 4 or
				string.match(avoidType,"Immunit\195\164t") and 3 or 1;
		-- Sanity check: must have avoided in some manner
		if (avoidType == 1) then return nil end
		return 1,initiatorName,targetName,skillName,0,avoidType,1,10;
	end
		
	-- miss
	local initiatorName, targetName, skillName = string.match(line, "^(.*) verfehlte (.*) mit (.*)%.");
	
	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		targetName = TrimArticles(targetName);
		skillName = string.gsub(skillName, "\"", "");
		local avoidType = 2;
		-- Update
		return 1,initiatorName,targetName,skillName,0,avoidType,1,10;
	end
		
	
	-- 5) Reflect line --
	
	local initiatorName, amount, reflectType, targetName = string.match(line, "^(.*) reflektierte ([%d,]*) Punkte (.*) von (.*).$");
	if(initiatorName ~= nil) then
		local skillName = "Reflektiert";
		initiatorName = TrimArticles(initiatorName);
		targetName = TrimArticles(targetName);
		
		amount = string.gsub(amount,",","")+0;
		local dmgType = string.match(reflectType, "^Schaden des Typs (.*) auf Moral$");
		
		if(dmgType ~= nil) then
			dmgType = 
				dmgType == "\"Allgemein\""  and 1 or
				dmgType == "\"Feuer\"" and 2 or
				dmgType == "\"Blitz\"" and 3 or
				dmgType == "\"Frost\"" and 4 or
				dmgType == "\"S\195\164ure\"" and 5 or
				dmgType == "\"Schatten\"" and 6 or
				dmgType == "\"Licht\"" and 7 or
				dmgType == "\"Beleriand\"" and 8 or
				dmgType == "\"Westernis\"" and 9 or
				dmgType == "\"Uralte Zwergenart\"" and 10 or
				dmgType == "\"Ork-Waffe\"" and 11 or
				dmgType == "\"Hass\"" and 12 or 13;
			-- a dmg reflect
			return 1,initiatorName,targetName,skillName,amount,1,1,dmgType;
		else
			-- a heal reflect
			return 3,initiatorName,targetName,skillName,amount,1;
		end
	end
	
	-- 6) Temporary Morale bubble line (as of 4.1.0)
	local amount = string.match(line,"^Ihr habt ([%d,]*) Punkte Moral (tempor\195\164r) verloren!$");
	if (amount ~= nil) then
		amount = string.gsub(amount,",","")+0;
		-- the only information we can extract directly is the target and amount
		return 14,nil,player.name,nil,amount;
	end
	
	-- 7) Combat State Break notice (as of 4.1.0)
	
	-- 7a) Root broken
	local targetName = string.match(line,"^.* hab?t die Bewegungslosigkeit von (.*) beendet!$");
	if (targetName ~= nil) then
		targetName = TrimArticles(targetName);
		-- the only information we can extract directly is the target name
		return 16,nil,targetName,nil;
	end
	
	-- 7b) Daze broken
	local targetName = string.match(line,"^.* hab?t die Benommenheit von (.*) beendet!$");
	if (targetName ~= nil) then
		targetName = TrimArticles(targetName);
		-- the only information we can extract directly is the target name
		return 16,nil,targetName,nil;
	end
	
	-- 7c) Fear broken
	local targetName = string.match(line,"^.* hab?t mit einem Angriff die Furcht von (.*) beseitigt!$");
	if(targetName ~= nil) then
		targetName = TrimArticles(targetName);
		-- the only information we can extract directly is the target name
		return 16,nil,targetName,nil;
	end
		
	
	-- 8) Interrupt line --
	local targetName,initiatorName = string.match(line,"^(.*) wurde durch (.*) unterbochen!");
	if (targetName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		targetName = TrimArticles(targetName);
		
		-- Update
		return 7,initiatorName,targetName;
	end
	
	-- 9) Dispell line (corruption removal) --
	local corruption, targetName = string.match(line,"Von (.*) geheilt: (.*)");
	
	if (corruption ~= nil) then
		-- NB: Currently ignore corruption name
		
		-- Update
		return 8,player.name,targetName;
	end
	
	-- 10) Defeat lines ---
	
	-- 10a) Defeat line 1 (mob or played was killed)
	local initiatorName = string.match(line,"^Durch .* besiegt: (.*)%.$");
	
	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		-- Update
		return 9,initiatorName;
	end
	
	-- 10b) Defeat line 2 (mob died)
	local initiatorName = string.match(line,"^(.*) ist gestorben%.$");
	
	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		-- Update
		return 9,initiatorName;
	end
	
	-- 10c) Defeat line 3 (a player was killed or died)
	local initiatorName = string.match(line,"^(.*) wurde besiegt%.$");

	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		-- Update
		return 9,initiatorName;
	end
	
	-- 10d) Defeat line 4 (you were killed)
	local match = string.match(line,"^.* hat Euch au\195\159er Gefecht gesetzt%.$");

	if (match ~= nil) then
		-- Update
		return 9,player.name;
	end
	
	-- 10e) Defeat line 5 (you died)
	local match = string.match(line,"^Ihr wurdet durch ein Missgeschick au\195\159er Gefecht gesetzt%.$");

	if (match ~= nil) then
		-- Update
		return 9,player.name;
	end
	
	-- 11) Revive lines --
	
	-- 11a) Revive line 1 (player revived)
	local initiatorName = string.match(line,"^(.*) wurde wiederbelebt%.$");
	
	if (initiatorName ~= nil) then
		initiatorName = TrimArticles(initiatorName);
		-- Update
	  return 10,initiatorName;
	end
	
	-- 11b) Revive line 2 (player succumbed)
	local initiatorName = string.match(line,"^(.*) ist .* Wunden erlegen%.$");
	
	if (initiatorName ~= nil) then
	  initiatorName = TrimArticles(initiatorName);
		-- Update
	  return 10,initiatorName;
	end
	
	-- 11c) Revive line 3 (you were revived)
	local match = string.match(line,"^Ihr wurdet wiederbelebt%.$");
	
	if (match ~= nil) then
		-- Update
	  return 10,player.name;
	end
	
	-- 11d) Revive line 4 (you succumbed)
	local match = string.match(line,"^Ihr erliegt Euren Verletzungen%.$");
	
	if (match ~= nil) then
		-- Update
	  return 10,player.name;
	end
	
	-- if we reach here, we were unable to parse the line
	--  (note there is very little that isn't parsed)
end
