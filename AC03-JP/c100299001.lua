--幻惑の眼
--Eye of Illusion
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_CYBERSE|RACE_ILLUSION),tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ak=Duel.GetAttacker()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup()
		and (e:GetLabel()==2 and chkc:IsControlerCanBeChanged() or e:GetLabel()==3 and chkc~=ak) end
	if chk==0 then return true end
	local b2=Duel.IsTurnPlayer(1-tp)
		and Duel.IsExistingTarget(aux.FaceupFilter(Card.IsControlerCanBeChanged),tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and ak:IsControler(1-tp)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,ak)
	local op=Duel.SelectEffect(tp,
		{true,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{b3,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
		e:SetProperty(0)
	elseif op==2 then
		e:SetCategory(CATEGORY_CONTROL)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsControlerCanBeChanged),tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,ak)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE|RACE_ILLUSION))
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.GetControl(tc,tp,PHASE_END,1)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local ak=Duel.GetAttacker()
			if ak:CanAttack() and not ak:IsImmuneToEffect(e) then
				Duel.CalculateDamage(ak,tc)
			end
		end
	end
end
