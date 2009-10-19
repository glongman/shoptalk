
#ShopTalk Demo Application

<p>ShopTalk is a demonstration mashup app that melds the VOIP services of <a href="http://cloudvox.com">CloudVox</a>  and the APIs provided by <a href="http://shopify.com">Shopify</a>> for 3rd Party app development.</p>

<p>In a nutshell a Shopify customer, a shop owner, can add the ShopTalk application to their shop and gain the ability to phone into that shop from a land line. In the current incarnation the caller, after identifying using an access code, is able to access the running total for orders placed in the shop that day.</p>
<h2>Trying it out</h2>
<p>
The procedure for trying out this code yourself involves creating both a free CloudVox account and a Shopify developer API account. The application must be publicly available to work and I've include instructions for hosting the app on <a href="http://heroku.com">Heroku</a>. Using Heroku is the easiest way I've found to get up and running quickly. 
<h2><a href="http://cloudvox.com/signup">Sign up for a free CloudVox account</a> and create a voice application</h2>

<p>
after signup create an application (mine is called ShopTalk)<br>
make note of the application phone # and extension<br>
to make free calls to your application you need to set up a Sip phone that talks to your Cloudvox account<br/>
I used <a href="http://help.cloudvox.com/faqs/sip-phones/x-lite">X-Lite 4 (beta)</a>.
</p>
<h2><a href="http://shopify.com/developers">Sign up as a Shopify developer</a> (also free)</h2>
<p>
create a Shopify application (mine was amazingly called ShopTalk)</br>
make note of the API key and secret
</p>
<h2>Get the code for this app</h2>
<p>
fork this project on GitHub </br>
clone it into your local environment
</p>
<h2><a href="http://heroku.com/signup">Sign up for a free Heroku account</a></h2>
<p>get the<a href="http://docs.heroku.com/heroku-command">Heroku gem</a></p>
<p><a href="http://docs.heroku.com/creating-apps">create the app< using the gem</p>
<p><a href="http://docs.heroku.com/git">deploy the app</a> using Git</p>
<p>migrate:</p>
<pre>heroku rake db:migrate</pre>       
<p>Set config variables (Shopify API key and secret + Cloudvox app)</p>   
<pre>    
       > heroku config:add \
            SHOPIFY_API_KEY=your-key \
            SHOPIFY_API_SECRET=your-secret
            SHOPTALK_LINE=your-cloudvox-phone-number-and-extension
</pre>
<p>Make note of the hostname Heroku assigned to your application
<pre>> heroku info</pre>

<h2>Configure your Shopify app</h2>

<p>add the post install callback url to your application running on Heroku</p>
<pre>http://your-host.heroku.com/admin/finalize</pre>
<h2> Configure your Cloudvox application</h2>
<p>When calls arrive a call plan is loaded from your application via an HTTP GET</p>
<p>Enter the url to your application on Heroku. like this...</p>
<pre>http://your-host.heroku.com/calls.json</pre>
<h2><a href="http://app.shopify.com/services/partners/api_clients/test_shops">Create a Test Shop</a> in Shopify and add your ShopTalk application to it</h2>
<p>Log in to the test shop as admin</p>
<p>Add some orders to your test shop.</p>
<p>Without logging out of the test shop, go to your app on heroku</p>
<pre>http://http://your-host.heroku.com</pre>
<p>Enter the url of your shopify test shop and you will be redirected back to the heroku app</p>
<p>Make note of the access code that is displayed on the ShopTalk homepage after installation</p>
<h2>Call!</h2>
<p>Dial the phone number of your Cloudvox application using your Sip phone</p>
<p>When prompted, enter the access code you wrote down earlier</p>
<p>Listen as the app reads to you information about orders created today.</p>
<h2>Example</h2>
<p>Here is a recording I made of the app running</p>
<p><a href="http://ff.im/a5Sln">http://ff.im/a5Sln</a></p>
<p>Feel free to leave a comment at that link.</p> 



