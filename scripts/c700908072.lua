--アモルファージ・ライシス
--Script by mercury233
function c700908072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DESTROY,TIMING_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c700908072.target1)
	e1:SetOperation(c700908072.operation)
	c:RegisterEffect(e1)
	--set p
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c700908072.condition)
	e2:SetTarget(c700908072.target2)
	e2:SetOperation(c700908072.operation)
	c:RegisterEffect(e2)
	--atk/def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c700908072.atktg)
	e3:SetValue(c700908072.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
end
function c700908072.filter(c,e,tp)
	return c:IsSetCard(0x1374) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c700908072.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7) and c:GetPreviousControler()==tp
end
function c700908072.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_DESTROYED,true)
	if res
		and e:GetHandler():GetFlagEffect(700908072)==0
		and Duel.IsExistingMatchingCard(c700908072.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and teg:IsExists(c700908072.cfilter,1,nil,tp)
		and Duel.SelectYesNo(tp,94) then
		e:GetHandler():RegisterFlagEffect(700908072,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c700908072.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c700908072.cfilter,1,nil,tp)
end
function c700908072.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and e:GetHandler():GetFlagEffect(700908072)==0
		and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c700908072.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	e:GetHandler():RegisterFlagEffect(700908072,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c700908072.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetFlagEffect(700908072)==0 then return end
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c700908072.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c700908072.atktg(e,c)
	return c:IsFaceup() and not c:IsSetCard(0x1374)
end
function c700908072.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1374)
end
function c700908072.atkval(e)
	return Duel.GetMatchingGroupCount(c700908072.vfilter,e:GetOwnerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-100
end
