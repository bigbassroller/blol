searchNodes=[{"doc":"","ref":"Blol.html","title":"Blol","type":"module"},{"doc":"Get Summoner by name. Examples iex&gt; Blol . get_summoner_by_name ( &quot;caitlyn&quot; , &quot;br1&quot; ) %{ &quot;accountId&quot; =&gt; &quot;smX0o8Z_BH83ovCdqw0Dp-9Y3Wwo56jaAmR5nAjsfpXn0KJvOqBnQHm4&quot; , &quot;id&quot; =&gt; &quot;oZQlmQJo2GxL3k0_hhA24tyo7QGeSAmMV2ACFjT0WVc3YTBB8Go_LBWJwQ&quot; , &quot;name&quot; =&gt; &quot;Caitlyn&quot; , &quot;profileIconId&quot; =&gt; 3542 , &quot;puuid&quot; =&gt; &quot;SDiyDhiGtOPeCVqoSZFY7UefS-9qhujyYppQYgAASdeeUtYdYE066Aak1SLfOry2XwVYvIW0lUgX7w&quot; , &quot;revisionDate&quot; =&gt; 1628245913000 , &quot;summonerLevel&quot; =&gt; 30 }","ref":"Blol.html#get_summoner_by_name/2","title":"Blol.get_summoner_by_name/2","type":"function"},{"doc":"Get Summoner matches. Examples iex&gt; Blol . get_summoner_matches ( &quot;caitlyn&quot; , &quot;br1&quot; , 5 ) [ &quot;BR1_2298956627&quot; , &quot;BR1_2298915613&quot; , &quot;BR1_2298934053&quot; , &quot;BR1_2298932595&quot; , &quot;BR1_2298931318&quot; ]","ref":"Blol.html#get_summoner_matches/3","title":"Blol.get_summoner_matches/3","type":"function"},{"doc":"Gets participants from summoner's previous matches and returns a list of maps with name and puuids. Examples iex&gt; Blol . get_summoner_participants ( &quot;caitlyn&quot; , &quot;br1&quot; , 5 ) %{ name : &quot;Antielialil&quot; , puuid : &quot;9bkwL40M-4ZE3_HHAdUwftBuTsac3s8tW9zFFRIy_ZEcTs9CAxupfp5QuKCC895HzgEXl1yuyPzy1w&quot; } , ...","ref":"Blol.html#get_summoner_participants/3","title":"Blol.get_summoner_participants/3","type":"function"},{"doc":"Montitors summoners participants for new matches for 1 hour. Examples iex&gt; Blol . monitor_summoner_matches ( &quot;caitlyn&quot; , &quot;br1&quot; , 5 ) [ &quot;Antielialil&quot; , &quot;...&quot; ] Later on ... &quot;Summoner Vno nameV completed match NA1_4142031064&quot;","ref":"Blol.html#monitor_summoner_matches/3","title":"Blol.monitor_summoner_matches/3","type":"function"}]