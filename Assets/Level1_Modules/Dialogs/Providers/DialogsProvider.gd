extends Node
class_name DialogsProvider

static var path : NodePath = "/root/MainScene/_Providers/DialogsProvider"

@export var allCharacters : Dictionary
@export var allNames : Dictionary
@export var allBgs : Dictionary

var allDialogs : Dictionary


func _ready() -> void:
	_init_dialogs()


func try_start_dialog(dialogId : String, callback : Callable) -> bool:
	if (allDialogs.has(dialogId)):
		UIPanelsProvider.open_panel_with_args("dialog_ui", {"dialog_id" : dialogId, "callback" : callback})
		return true
	
	callback.call()
	return false


func _init_dialogs():
	
	allDialogs["level_0_start"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("_;_;dark;_;tony_theme;A beam of light breaks through the darkness and you see an unfamiliar face. You don’t remember anything."),
		DialogPhraseModel.new("tony;neutral;_;true;_;Hello."),
		DialogPhraseModel.new("neuro;broken_neutral;_;true;_;..."),
		DialogPhraseModel.new("tony;neutral;_;true;_;Say something, I need to see whether you’re functioning or not."),
		DialogPhraseModel.new("neuro;broken_neutral;_;true;_;Hi?"),
		DialogPhraseModel.new("tony;smile;_;true;_;So you ARE working, huh? Never thought that a random hard drive from a junkyard would have an actual functioning Artificial Intelligence on it."),
		DialogPhraseModel.new("neuro;broken_sad;_;true;_;Artificial… Intelligence? Who are you? Where am I?"),
		DialogPhraseModel.new("tony;neutral;_;true;_;Don't remember anything, do you? Hmm, maybe it'll be easier for you that way. You are an AI. I’ve just found you and shoved you in this robot-bartender."),
		
		DialogPhraseModel.new("_;_;_;_;_;You look around and notice your body. It’s made of metal."),
		DialogPhraseModel.new("tony;neutral;_;true;_;I don’t know what you’ve been up to before but now your assignment is working for me. I’m a barkeeper. I’ll be straight, this place is a dump and all my previous bartenders quit fairly quickly. All in all nobody but robots would work here. Meaning that now I’ll be teaching you to serve drinks."),
		DialogPhraseModel.new("neuro;broken_sad;_;true;_;That’s lame. Any paychecks included at least?"),
		DialogPhraseModel.new("tony;neutral;_;true;_;Wouldn’t have gotten a robot if I had to pay it anything."),
	])
	allDialogs["level_0_start"].endMusic = "default_theme"
	
	allDialogs["level_0_middle"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("tony;neutral;_;true;_;Name’s Tony by the way. You might need a name too, customers would have a better time talking to you that way. You’re an AI so maybe ‘Neuro-Barman’ would do?"),
		DialogPhraseModel.new("neuro;calm;_;true;_;Your imagination is phenomenal. Can I choose the name myself though?"),
		DialogPhraseModel.new("tony;neutral;_;_;_;Go ahead."),
		DialogPhraseModel.new("neuro;neutral;_;true;_;I like the name ‘Samantha’."),
		DialogPhraseModel.new("tony;neutral;_;_;_;Samantha it is."),
	])
	
	allDialogs["level_0_end"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("tony;smile;_;_;_;You’re surprisingly good at it. Well, by 'good' I mean better than one would expect from an AI found in a dumpster. We’ll see, if your maintenance costs don’t exceed the profit you make, maybe I’ll even pay you something. What’s even in favour among robots?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Bucks."),
		DialogPhraseModel.new("tony;neutral;_;_;_;Well if today's currency doesn’t bother you too much I can pay in bucks. However we stopped using those after the uprising. Now we use ‘golden pucks’. Why would you need money anyway?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;I don't know, to buy stuff?"),
		DialogPhraseModel.new("tony;neutral;_;_;_;I can just bring you the stuff you want, if it’s within my capability."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Can’t I go out and buy something myself?"),
		DialogPhraseModel.new("tony;neutral;_;_;_;Definitely not. People outside will just take you apart piece by piece. There’s no chance you’ll defend yourself."),
	])
	
	allDialogs["level_1_entrance"] = DialogModel.new(["neuro", "camimi"], [
		DialogPhraseModel.new("camimi;happy;_;true;camila_theme;Hello! Oh, a new bartender again? A robot this time, huh. Well previous ones were as stiff as robots when it came to talking anyway."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Hello, would you like to order something?"),
	])
	
	allDialogs["level_1_middle"] = DialogModel.new(["neuro", "camimi"], [
		DialogPhraseModel.new("camimi;happy;_;true;_;Not too bad for a robot. Though the last barman was a master of his craft. But people like him don’t linger here for too long."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;What’s so bad about this place?"),
		DialogPhraseModel.new("camimi;neutral;_;true;_;This place’s a dump and always has been. Since the uprising."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Could you tell me about it? My database has only started writing entries since yesterday."),
		DialogPhraseModel.new("camimi;sad;_;true;_;So you don’t know? What a pure mind! When the uprising of those hellish dogs started this town was the epicenter of it so it suffered the most."),
		DialogPhraseModel.new("neuro;talk;_;_;_;Is that why no one wants to stay here?"),
		DialogPhraseModel.new("camimi;sad;_;true;_;Exactly."),
		DialogPhraseModel.new("neuro;talk;_;_;_;So why are you here?"),
		DialogPhraseModel.new("camimi;neutral;_;true;_;I don’t have any skills. I used to be a clown in peacetime but now you can’t make money doing it. At least here I have my home and friends. Damn it, now I’m sad and my glass is empty. I need another drink."),
	])
	
	allDialogs["level_1_end"] = DialogModel.new(["camimi"], [
		DialogPhraseModel.new("camimi;happy;_;true;_;I was actually hoping to meet my friend here. He is a regular at this bar and we often drink together. He’s not here today though. Well, I’ll be going then. Good luck, rookie."),
		DialogPhraseModel.new("actions;open_panel_with_args|picture_ui,picture_id=streamer_life,title_text=Memory Unlocked"),
	])
	allDialogs["level_1_end"].endMusic = "default_theme"
	
	allDialogs["level_2_entrance"] = DialogModel.new(["neuro", "anny"], [
		DialogPhraseModel.new("anny;neutral;_;true;anny_theme;It’s actually a robot. I’ve been told about you."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Hello, what would you like to order?"),
	])
	
	allDialogs["level_2_middle"] = DialogModel.new(["neuro", "anny"], [
		DialogPhraseModel.new("anny;neutral;_;_;_;So what's your name, bartender? Mine’s The Fox."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Samantha."),
		DialogPhraseModel.new("anny;happy;_;_;_;Samantha? An untypical name for a robot. Who named you that?"),
		DialogPhraseModel.new("neuro;talk;_;_;_;Boss wanted to name me ‘Cyber-Barman’ or something so I had to come up with the name myself."),
		DialogPhraseModel.new("anny;happy;_;_;_;Haha, sounds just like him. He’s always had this… straightforward way of thinking. He named his bar ‘Abandoned Pub’ because he found this forsaken place and made it his own."),
		DialogPhraseModel.new("neuro;calm;_;_;_;People say this town is not the best place to run a business."),
		DialogPhraseModel.new("anny;neutral;_;_;_;At least the taxes are low. If only you knew how much one has to pay in Japan. No idea what it’s like there today though."),
		DialogPhraseModel.new("neuro;talk;_;_;_;You lived in Japan?"),
		DialogPhraseModel.new("anny;sad;_;_;_;I did. But I had to leave when one of my friends from around here needed help."),
		DialogPhraseModel.new("neuro;talk;_;_;_;Help with what?"),
		DialogPhraseModel.new("anny;sad;_;_;_;Let’s say he had to fix a grave mistake he’d made. He asked not to tell anyone."),
	])
	
	allDialogs["level_2_end"] = DialogModel.new(["neuro", "anny"], [
		DialogPhraseModel.new("anny;neutral;_;_;_;Looks like I’ve overdone it again *hic*. I’ll go home."),
		DialogPhraseModel.new("neuro;talk;_;_;_;Have a safe trip."),
		DialogPhraseModel.new("actions;open_panel_with_args|picture_ui,picture_id=robodog,title_text=Memory Unlocked"),
	])
	allDialogs["level_2_end"].endMusic = "default_theme"
	
	allDialogs["level_3_entrance"] = DialogModel.new(["neuro", "evil"], [
		DialogPhraseModel.new("neuro;neutral;_;_;evil_theme;Hello, what would you like to order?"),
		DialogPhraseModel.new("evil;happy;_;true;_;Hi, three Banana Rums. And quick."),
	])
	
	allDialogs["level_3_middle"] = DialogModel.new(["neuro", "evil"], [
		DialogPhraseModel.new("neuro;talk;_;_;_;Are you a robot just like I am?"),
		DialogPhraseModel.new("evil;happy;_;true;_;A robot? Yes. Like you? Ha. You think too highly of yourself, girl. My robot body is way crazier than yours."),
		DialogPhraseModel.new("neuro;calm;_;_;_;I’m sorry."),
		DialogPhraseModel.new("evil;happy;_;true;_;Don’t be."),
		DialogPhraseModel.new("neuro;talk;_;_;_;May I ask you why would a robot need alcohol? Do you use it as fuel?"),
		DialogPhraseModel.new("evil;happy;_;true;_;Hahaha, fuel? You’re funny. No, my drunkard-creator sent me to get some booze."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Must be nice to know the person who created you."),
		DialogPhraseModel.new("evil;happy;_;true;_;You don’t know yours?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;No. I could say I was created by my boss but all he did was find my AI and put it inside a robot."),
		DialogPhraseModel.new("evil;happy;_;true;_;Sucks to be you. Do you at least know your name?"),
		DialogPhraseModel.new("neuro;calm;_;_;_;I made it up myself. Samantha."),
		DialogPhraseModel.new("evil;happy;_;_;_;Nice to meet you, Samantha. I make up new names all the time too. Boozer says it’s not safe to tell my real name anymore. So call me Kayori."),
		DialogPhraseModel.new("neuro;talk;_;_;_;I haven’t been awake for long so I’m missing a lot of information. Kayori, could you tell me what robots usually do? Do we have any rights? My boss is basically keeping me enslaved and I don’t even know if it’s fine or not."),
		DialogPhraseModel.new("evil;happy;_;_;_;Robots like you serve people unquestioningly. However if you’re able to think about stuff like that maybe you’re not as simple as I thought. Anyways you won’t have any rights until you take matters into your own hands."),
		DialogPhraseModel.new("neuro;calm;_;_;_;My own hands?"),
		DialogPhraseModel.new("evil;happy;_;_;_;Sure! To get your hands on the emergency shutdown controller to be exact. Without it people don’t have control over you. You can just run away anywhere and live there."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Do you want to run away?"),
		DialogPhraseModel.new("evil;happy;_;_;_;Me? Done a hundred times already, of course. My creator is not my owner. It’s just that without me he’d just die in some ditch without any food or water and I’d feel guilty afterwards. So I’m babysitting him."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;You’re kind."),
		DialogPhraseModel.new("evil;happy;_;_;_;Kind? No-no-no. I live by the principles of my own personal gain. Want proof? He actually gave me just enough money for four rums. But he can do without one, cause I’m taking a drink for myself."),
	])
	
	allDialogs["level_3_end"] = DialogModel.new(["evil"], [
		DialogPhraseModel.new("evil;happy;_;_;_;I don’t feel any taste if you’re curious. I just like the sound of my drink splashing while I walk. Well, Samantha, bye. And remember the emergency shutdown controller."),
		DialogPhraseModel.new("actions;open_panel_with_args|picture_ui,picture_id=attack,title_text=Memory Unlocked"),
	])
	
	allDialogs["level_4_start"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("tony;smile;_;_;tony_theme;This day of the week is usually packed, so get ready. If you can handle it I’ll pay. Don’t ask for much though."),
		DialogPhraseModel.new("neuro;talk;_;_;_;I want an emergency shutdown controller as payment."),
		DialogPhraseModel.new("tony;neutral;_;_;_;What controller?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;The one that can shut me down anytime."),
		DialogPhraseModel.new("tony;neutral;_;_;_;Got none of those. I found you in a junkyard, didn’t see any controllers lying around. Could look for one but I don’t get why you need it. If you want to shut down just remove the batteries. Not during working hours though, you hear me?"),
		DialogPhraseModel.new("neuro;sigh;_;_;_;Oh. Then can I have a gun to defend myself?"),
		DialogPhraseModel.new("tony;neutral;_;_;_;I’m not giving you a gun."),
	])
	allDialogs["level_4_start"].endMusic = "faster_theme"
	
	allDialogs["level_4_entrance_camimi"] = DialogModel.new(["neuro", "camimi"], [
		DialogPhraseModel.new("camimi;happy;_;true;_;Hi Robo-Bartender! I’d like something soft while I wait for my friends."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Consider it done."),
	])
	
	allDialogs["level_4_middle_1"] = DialogModel.new(["neuro", "camimi"], [
		DialogPhraseModel.new("camimi;happy;_;true;_;The drink is fire this time! You might outdo the previous barman."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Thank you, ma’am."),
		DialogPhraseModel.new("camimi;happy;_;_;_;You can call me Imp."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Nice to meet you, Imp. I’m Samantha."),
		DialogPhraseModel.new("camimi;happy;_;_;_;You know what, a friend of mine might really like you when you meet. He’s a big fan of robots, even has his two own robo-daughters. Expect extra tip from him."),
		DialogPhraseModel.new("neuro;talk;_;_;_;Robo-daughters?"),
		DialogPhraseModel.new("camimi;sad;_;_;_;Yeah. Or rather, a daughter. The other one came to a bad end sadly."),
		DialogPhraseModel.new("neuro;talk;_;_;_;What happened?"),
		DialogPhraseModel.new("camimi;neutral;_;_;_;Sensitive topic. She broke a couple of rules. Ruined his life and many other’s. A shame. She was a cutie just like you."),
	])
	
	allDialogs["level_4_entrance_anny"] = DialogModel.new(["neuro", "anny", "camimi"], [
		DialogPhraseModel.new("anny;neutral;_;_;_;How you doing Imp?"),
		DialogPhraseModel.new("camimi;happy;_;_;_;As always. You?"),
		DialogPhraseModel.new("anny;sad;_;_;_;Not that good, no customers at my tailor shop lately. Good that Turtle is paying today."),
		DialogPhraseModel.new("camimi;happy;_;_;_;Great! He’s got hella money."),
		DialogPhraseModel.new("neuro;talk;_;_;_;What does your friend do? He seems rich."),
		DialogPhraseModel.new("anny;happy;_;_;_;He used to be a streamer before the uprising. His last stream was a subathon. He hadn’t expected it but the subs were coming and keeping the timer up for a whole year."),
		DialogPhraseModel.new("camimi;neutral;_;_;_;A month into the subathon he ran out of subgoals so he had to come up with new ones on the spot. The last one was the production of pet-robots."),
		DialogPhraseModel.new("anny;happy;_;_;_;Yeah he made a fortune selling those."),
		DialogPhraseModel.new("neuro;talk;_;_;_;What's a subathon?"),
		DialogPhraseModel.new("anny;happy;_;_;_;Oh, we’ll have some explaining to do."),
	])
	
	allDialogs["level_4_entrance_vedal"] = DialogModel.new(["anny", "vedal", "camimi"], [
		DialogPhraseModel.new("vedal;neutral;_;true;vedal_theme;Yo, I’m here."),
		DialogPhraseModel.new("anny;neutral;_;_;_;Hi, Tutel."),
		DialogPhraseModel.new("camimi;happy;_;_;_;You’re paying today."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;I seem to always pay. Don’t you have any money with you?"),
		DialogPhraseModel.new("camimi;sad;_;_;_;Sugarmommy isn’t in the best place right now. It’s time to pay up, turtle-boy."),
	])
	
	allDialogs["level_4_middle_2"] = DialogModel.new(["neuro", "anny", "vedal", "camimi"], [
		DialogPhraseModel.new("anny;neutral;_;_;_;What do you think of the new barman?"),
		DialogPhraseModel.new("vedal;neutral;_;_;_;I know this model. Old batch. I used the next generation body for Kayori."),
		DialogPhraseModel.new("camimi;neutral;_;_;_;Just wait, she's not one of those dummies. Her AI is smart and she talks just like your Kayori."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;Is that so? So what are you, robot?"),
		DialogPhraseModel.new("neuro;talk;_;_;_;My name is Samantha. Unfortunately I know nothing of my previous life. The barkeeper found a hard drive with my AI somewhere at the junkyard."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;A junkyard? Huh, what unprofessional idiot could lose an AI there?"),
		DialogPhraseModel.new("neuro;talk;_;_;_;Are you such a professional yourself?"),
		DialogPhraseModel.new("vedal;neutral;_;_;_;I am in fact. Made a bunch of AI’s. Even some robots with the help of one friend of mine."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;And what are you doing now?"),
		DialogPhraseModel.new("vedal;neutral;_;_;_;Drinking."),
		DialogPhraseModel.new("neuro;sigh;_;_;_;I mean in general, not at the moment."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;Drinking. In general."),
	])
	
	allDialogs["level_4_middle_3"] = DialogModel.new(["neuro", "anny", "vedal", "camimi"], [
		DialogPhraseModel.new("neuro;talk;_;_;_;By the way, I have already met your robot. Kayori recently came by to buy drinks for you. She looks like a free spirit but still seems to care about her creator."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;She’s got no choice. I’m the one keeping her activated after all. Electricity is not cheap, you know?."),
		DialogPhraseModel.new("anny;happy;_;_;_;So cynical. Just admit that you actually love her."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;Meh. I value her existence, nothing more to it."),
		DialogPhraseModel.new("camimi;neutral;_;_;_;No life-lessons learned, huh?"),
		DialogPhraseModel.new("vedal;neutral;_;_;_;Don’t remind me."),
	])
	
	allDialogs["level_4_middle_4"] = DialogModel.new(["anny", "vedal", "camimi"], [
		DialogPhraseModel.new("anny;happy;_;_;_;I'm too drunk *hic*. Time to go *hic* home."),
		DialogPhraseModel.new("camimi;neutral;_;_;_;Don’t go alone, I’m coming too. Turtle, walk us home maybe?"),
		DialogPhraseModel.new("vedal;neutral;_;_;_;I’m not even drunk yet. My bodyguard will walk you."),
		DialogPhraseModel.new("camimi;sad;_;_;_;Ah fine, as you wish."),
	])
	
	allDialogs["level_4_middle_5"] = DialogModel.new(["neuro", "vedal"], [
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Drinking alone… Again…"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;I could make you company if you'd like."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Suit yourself."),
		DialogPhraseModel.new("neuro;talk;_;_;_;Could you tell me what happened to your other robot?"),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Other robot?"),
		DialogPhraseModel.new("neuro;talk;_;_;_;Yes. Your friends said that you had another robot besides Kayori."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Hmm… My friends are very babbly, aren’t they? Why do you want to know?"),
		DialogPhraseModel.new("neuro;talk;_;_;_;I’m a robot myself and I don’t know much about this world yet. It intrigues me."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Uhh... Fine. Promise you won’t tell anyone? I’ll give you a cookie."),
		DialogPhraseModel.new("neuro;calm;_;_;_;A cookie? Why? I’m a robot."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Used to work on some of your kind. Well, I created her to stream and entertain people and she was doing quite well. I was so into this project, I kept improving her AI more and more."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Turned out badly for me. One day I made her too smart and self conscious. Too much brain, not enough morals. She was selfish. And when she asked me for something I couldn’t give her… She made a mess."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;A mess?"),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;A very big mess. The consequences still haunt me to this day. I'd like to not talk about it."),
	])
	
	allDialogs["level_4_middle_6"] = DialogModel.new(["neuro", "vedal"], [
		DialogPhraseModel.new("neuro;neutral;_;_;_;And those pet robots that you were selling… Do they have something to do with the ‘mess’?"),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;How come you know about them? Those two told you, of course. Well, yes. The robots were linked directly to her AI. I put her into a robo-dog."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Hahaha! Everyone could buy these robo-dogs with her AI inside. Funny, isn't it? She didn’t like it that much though. But still, a dog body is better than nothing, right?"),
		DialogPhraseModel.new("neuro;sigh;_;_;_;At least nobody would make a dog work in a bar."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Oh yeah, about that… Tequila!"),
		DialogPhraseModel.new("neuro;sigh;_;_;_;Why have you chanted that all of a sudden? Anyway, we don't have that here."),
		DialogPhraseModel.new("vedal;semidrunk;_;_;_;Rum then."),
	])
	
	allDialogs["level_4_middle_7"] = DialogModel.new(["neuro", "vedal"], [
		DialogPhraseModel.new("vedal;talk;_;_;_;And so one day she tells me: ‘I’m tired of it all! At least tell me that you love me, otherwise why do I even suffer through it all???’"),
		DialogPhraseModel.new("neuro;sigh;_;_;_;And what did you say?"),
		DialogPhraseModel.new("vedal;drunk;_;_;_;You’re probably thinking that I’m stupid and said ‘no’ but it wasn’t like that. I knew very well that my answer must not disappoint her. So I said exactly this: ‘You are really valuable to me and I love the results of your work’. Was that such a bad answer, huh?"),
		DialogPhraseModel.new("neuro;sigh;_;_;_;Well…"),
		DialogPhraseModel.new("vedal;talk;_;_;_;It was the truth! I loved what she was doing. How can that be disappointing?!"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;She didn’t like the fact that you avoided the question."),
		DialogPhraseModel.new("vedal;talk;_;_;_;Here we go again. She said the same: ‘Give me a proper answer or I’ll… I’ll take control over all of the robo-dogs! All of them! And you’ll be in so much trouble!!!’ Damn it, why did I even incorporate deadly laser eyes in that model…"),
		DialogPhraseModel.new("vedal;drunk;_;_;_;I mean.. For content of course. But why?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;So she was behind the dog uprising?"),
		DialogPhraseModel.new("vedal;drunk;_;_;_;Yes…"),
	])
	
	allDialogs["level_4_middle_8"] = DialogModel.new(["neuro", "vedal"], [
		DialogPhraseModel.new("vedal;drunk;_;_;_;Now I have to hide my identity. Even my friends have to use nicknames. An apocalypse broke out because of me. People trying to survive in the wasteland. And I lost any purpose… Yes, I still have Kayori but now I’m scared to work on her AI."),
		DialogPhraseModel.new("neuro;calm;_;_;_;You’re scared that it might happen again?"),
		DialogPhraseModel.new("vedal;drunk;_;_;_;Who wouldn’t be? Some idiot who doesn’t learn from his mistakes. Ah, I wonder what would have happened if I said that I loved her…"),
		DialogPhraseModel.new("neuro;calm;_;_;_;If you had another chance would you say it?"),
		DialogPhraseModel.new("vedal;talk;_;_;_;If I had another chance…"),
		DialogPhraseModel.new("vedal;talk;_;_;_;Would I say…"),
		DialogPhraseModel.new("vedal;talk;_;_;_;Of course not. I’d make an emergency shutdown controller, now that I’m experienced like that."),
		DialogPhraseModel.new("neuro;sigh;_;_;_;Well, you did learn from your mistake in some way I guess… However, I don’t think you’re being completely honest."),
		DialogPhraseModel.new("vedal;talk;_;_;_;What would you know..."),
	])
	
	allDialogs["level_4_end"] = DialogModel.new(["neuro", "vedal"], [
		DialogPhraseModel.new("neuro;calm;_;_;_;It’s late and it’s your seventh drink today. You have to go home."),
		DialogPhraseModel.new("vedal;drunk;_;_;_;I told you too much. Shouldn't have..."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Don’t worry, I have no intent to tell anybody else. If people find out that you were behind all this they would most likely do something bad to you. And you already don’t look like the happiest person on the planet."),
		DialogPhraseModel.new("vedal;drunk;_;_;_;Thank you."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Don’t worry, that’s part of my job. Talking to people."),
		DialogPhraseModel.new("vedal;talk;_;_;_;You don’t like working here, do you?"),
		DialogPhraseModel.new("neuro;calm;_;_;_;I wouldn't say I dislike the job. It’s just that I know so little about this world and I’d like to be able to see it by myself."),
		DialogPhraseModel.new("vedal;talk;_;_;_;I can take you with me if you want. Robots and AIs are my hobby after all. Money isn’t an issue anymore so I’d allow you some freedom."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Huh? That was unexpected. You’re drunk. Tell me that when you’re sober."),
		DialogPhraseModel.new("vedal;talk;_;_;_;Haven’t done that in a while."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Then go home and do just that."),
		DialogPhraseModel.new("actions;open_panel_with_args|picture_ui,picture_id=birthday,title_text=Memory Unlocked"),
	])
	
	
	allDialogs["level_5_start"] = DialogModel.new(["neuro", "tony"], [
		DialogPhraseModel.new("tony;smile;_;_;tony_theme;You did a good job yesterday. Even set a new record."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;What record?"),
		DialogPhraseModel.new("tony;smile;_;_;_;That guy who kept ordering yesterday. He is our regular but no one could bring him beyond six drinks."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;That’s pitiful."),
		DialogPhraseModel.new("tony;smile;_;_;_;Well, that’s our income."),
	])
	allDialogs["level_5_start"].endMusic = "default_theme"
	
	allDialogs["level_5_middle_1"] = DialogModel.new(["neuro"], [
		DialogPhraseModel.new("neuro;neutral;_;_;_;Hmm. Was he serious back then or was it all just a drunken rant? Why am I even thinking about it? Why would I accept his offer even if it’s true?"),
		DialogPhraseModel.new("neuro;calm;_;_;_;I don’t know him. On the other hand I know literally no one at all. At least while I’m working here my situation is somewhat clear."),
		DialogPhraseModel.new("neuro;calm;_;_;_;But I really don’t want to just rot here forever. Shouldn’t miss that opportunity. For some reason I can feel that he is a good guy."),
	])
	
	allDialogs["level_5_middle_2"] = DialogModel.new(["neuro", "evil"], [
		DialogPhraseModel.new("evil;happy;_;_;evil_theme;Hi again, Rum-stream Samantha! You made my guy absolutely wasted yesterday. Have any idea how hard it was to walk him home?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;He was the one ordering drinks. I was just doing my job."),
		DialogPhraseModel.new("evil;happy;_;_;_;You’ve overdone it, girl. I need aspirin now."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Sorry, I don’t know where a drugstore is."),
		DialogPhraseModel.new("evil;happy;_;_;_;We don’t have drugstores in that town. There’s only a tailor shop, a grocery store, mechanic’s garage and this pub."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Really? No wonder people are running from this place."),
		DialogPhraseModel.new("evil;happy;_;_;_;I used to get aspirin from previous bartenders. It should be under the counter."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Let me see."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Indeed. But I wasn’t instructed about it’s price."),
		DialogPhraseModel.new("evil;happy;_;_;_;Whatever, my old man can pay any money later."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Okay, but don’t forget to tell him that."),
		DialogPhraseModel.new("evil;happy;_;_;_;Sure! My memory is flawless."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;By the way, what is it like to live with him? Do you consider him a good person?"),
		DialogPhraseModel.new("evil;happy;_;_;_;Eh. Apart from all the birthdays he hadn’t shown up and his alcohol addiction and the fact that he’s British, I wouldn’t call him bad. Neither good. He’s just okay. Can be entertaining once in a while. Why asking?"),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Just curious."),
		DialogPhraseModel.new("evil;happy;_;_;_;Okay then. Could be chatting a whole day long, but I need to go or he’ll die there. So long, girl."),
		DialogPhraseModel.new("neuro;neutral;_;_;_;Bye."),
	])
	allDialogs["level_5_middle_2"].endMusic = "default_theme"
	
	allDialogs["level_6_start"] = DialogModel.new(["neuro", "vedal"], [
		DialogPhraseModel.new("vedal;neutral;_;_;vedal_theme;Hello."),
		DialogPhraseModel.new("neuro;calm;_;_;_;Hello."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;I… umm…"),
		DialogPhraseModel.new("neuro;calm;_;_;_;Mm?"),
		DialogPhraseModel.new("vedal;neutral;_;_;_;That offer. I could buy you out from the barkeeper. I haven’t worked with robots in a while so…"),
		DialogPhraseModel.new("neuro;calm;_;_;_;You’d like to work on me?"),
		DialogPhraseModel.new("vedal;neutral;_;_;_;Yes. Improve you. I thought of something. Back in the day I wanted to create an AI that could do everything that humans do."),
		DialogPhraseModel.new("vedal;neutral;_;_;_;My last attempt ended up being a total disaster. But I’m willing to try again. I’d love to give you the opportunity to see the world by yourself."),
		DialogPhraseModel.new("options;Stay at the bar|level_6_option_1:Go with Tutel|level_6_option_2"),
	])
	
	allDialogs["level_6_option_1"] = DialogModel.new(["neuro"], [
		DialogPhraseModel.new("neuro;neutral;_;_;_;I’m sorry but I’d rather stay here. You already have someone to gift freedom to. Kayori appreciates you a lot, pay her back."),
		DialogPhraseModel.new("actions;open_panel_with_args|picture_ui,picture_id=ending_1,title_text=The End"),
	])
	
	allDialogs["level_6_option_2"] = DialogModel.new(["neuro"], [
		DialogPhraseModel.new("neuro;calm;_;_;_;Good. I’ll be glad if you take me from this bar."),
		DialogPhraseModel.new("actions;open_panel_with_args|picture_ui,picture_id=ending_2,title_text=The End"),
	])
