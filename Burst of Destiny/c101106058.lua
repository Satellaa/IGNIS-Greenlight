--ふわんだりぃずと謎の地図
--Flundereeze and the Mysterious Map
--Scripted by Zefile
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reveal
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	--normal on normal
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.nscon)
	e3:SetTarget(s.nstg)
	e3:SetOperation(s.nsop)
	c:RegisterEffect(e3)
end
s.listed_series={0x268}
function s.filter(c,tp)
	return c:IsSetCard(0x268) and c:GetLevel()==1 and c:IsSummonable(true,nil) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.filter2(c,code)
	return c:IsSetCard(0x268) and c:IsAbleToRemove() and not c:IsCode(code)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,POS_FACEUP,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g1>0 then
		Duel.ConfirmCards(1-tp,g1)
		local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetCode())
		if #g1>0 and #g2>0 then
			Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
			local sg=g1:GetFirst(tp,1,1,nil)
			Duel.Summon(tp,sg,true,nil)
		end
	end
end
function s.nsfilter(c)
	return c:IsSetCard(0x268) and c:IsSummonable(true,nil)
end
function s.nscon(e,tp,eg,ep,ev,re,r,rp)
	return eg and ep~=tp
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local sg=g:GetFirst(tp,1,1,nil)
		Duel.Summon(tp,sg,true,nil)
	end
end
