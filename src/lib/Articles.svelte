<script>
    //make list of articles
    let articles = [];
    let name = "";
    let price = 0;

    //get all articles from localstorage and add them to articles
    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("article")){
            let article = JSON.parse(localStorage.getItem(key));
            articles.push(article);
        }
        console.log(articles)
    }

    function generateId() {
        let id = Math.floor(Math.random() * 100000);
        while (articles.find((article) => article.id === id)) {
            id = Math.floor(Math.random() * 100000);
            if(articles.length === 100000){
                throw new Error("No more ids available");
            }
        }
        return id;
    }

    //create a function to add a new article
    function addNewArticle(name, price){
        let articlename = name;
        let ArticleID = generateId();
        let newArticle = ({
            id: ArticleID,
            name: articlename,
            price: price,
        })
        //Add new article to localstorage
        localStorage.setItem("article" + newArticle.id, JSON.stringify(newArticle));
        //Add new article to articles
        articles = [...articles, newArticle];
    }

    //remove article from local storage
    function removeArticleFromLocalStorage(id){
        localStorage.removeItem("article" + id);
        articles = articles.filter((article) => article.id !== id);
    }


</script>
<h1>Articles</h1>
<ul>
    <div>
        <p>Article id</p>
        <p>Article name</p>
        <p>Price</p>
    </div>
    {#each articles as article}
    <li>
        <div>
            <p>{article.id}</p>
            <p>{article.name}</p>
            <p>{article.price} kr/st</p>
            <button class="delete-button" on:click={()=>{removeArticleFromLocalStorage(article.id)}}>x</button>
        </div>
    </li>
    {:else}
    <p class="no-articles">Press the + button below to add a new article.</p>
    {/each}
</ul>
<div class="inputContainer">
    <div>
        <p class="input-label">Article</p>
        <p class="input-label">Price</p>
    </div>
    <div class="input-container">
        <input type="text" placeholder="Article name" bind:value={name}>
        <input type="number" placeholder="Baseline price" bind:value={price}>
        <button on:click={()=>{
            addNewArticle(name, price) 
            name = ""
            price = 0
        }}>+</button>
    </div>
</div>

<style>
    .input-label{
        width: 230px;
    }
    .inputContainer{
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        margin-bottom: 50px;
        text-align: left;
    }
    .input-container{
        display: flex;
        flex-direction: row;
        justify-content: center;
        margin-bottom: 50px;
    }
    input{
        margin: 10px 8px;
        margin-right: 8px;
    }
    .no-articles{
        margin-top: 5rem;
        width: 100%;
        margin-bottom: 5rem;
    }
    div{
        display: flex;
        flex-direction: row;
        justify-content: center;
        margin: 0px;
        padding: 0px;
    }
    ul{
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        margin-bottom: 10px;
        padding: 0px; 
        margin: 20px 100px;
    }
    li{
        display: flex;
        flex-direction: column;
        align-items: center;
        list-style: none;
        background-color: white;
        padding: 0px;
        border-radius: 10px;
        height: 50px;
        width: 500px;
        float: left;
        position: relative;
        transition: height 0.5s;
        -webkit-transition: height 0.5s;
        overflow: hidden;
        margin: 5px;
    }
    p{
        width: 130px;
        height: 20px;
        padding: 0;
    }
    button{
        margin: 15px;
        margin-left: 0px;
        color: green;
        font-size: 20px;
        font-weight: 900;
        display: inline-block;
    }

    button:hover{
        cursor: pointer;
    }
    .delete-button{
        position: absolute;
        background-color: darkred;
        color: white;
        border-radius: 0px 10px 10px 0px;
        width: 50px;
        height: 50px;
        font-size: small;
        right: 0px;
        margin: 0;
        padding: 0;
    }
    .delete-button:hover{
        background-color: red;
        border-radius: 0px 10px 10px 0px;
    }
</style>