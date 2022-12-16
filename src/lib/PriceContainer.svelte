<script>
    let search = "";
    let price;
    let articleToAdd;
    //get list of clients from localstorage
    let clients = [];
    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("client")){
            let client = JSON.parse(localStorage.getItem(key));
            clients.push(client);
        }
    }

    function generateId() {
        let id = Math.floor(Math.random() * 100000);
        while (clients.find((client) => client.id === id)) {
            id = Math.floor(Math.random() * 100000);
            if(clients.length === 100000){
                throw new Error("No more ids available");
            }
        }
        return id;
    }

    //get list of articles from localstorage
    let articles = [];
    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("article")){
            let article = JSON.parse(localStorage.getItem(key));
            articles.push(article);
        }
    }

    //add new price to client
    function addNewPrice(client, articleToAdd, price){
        //find article in articles
        let articleToGivePrice = articles.find((article) => article.id === articleToAdd);
        let articleObjToAdd = articleToGivePrice;
        let newPrice = {
            id: generateId(),
            article: articleObjToAdd,
            price: price
        }
        client.prices.push(newPrice);
        localStorage.setItem("client" + client.id, JSON.stringify(client));
        clients = [...clients];
    }

    function removePriceFromClient(client, priceId){
        client.prices = client.prices.filter((price) => price.id !== priceId);
        localStorage.setItem("client" + client.id, JSON.stringify(client));
        clients = [...clients];
    }
</script>

<li>
    <div>
        <p class="h">{client.name}<p/>
    </div>
    <div>
        <p>Article</p>
        <p>Price</p>
    </div>
    {#each client.prices as price}
    <div class ="table-container">
        <div>
            <p>{price.article.id}-{price.article.name}</p>
            <p>{price.price} kr/st</p>
        </div>
        <button class="remove" on:click={
            //remove price from client
            ()=>{
                removePriceFromClient(client, price.id);
            }
        }>x</button>
    </div>
    {/each}
    <div>
        <select bind:value={articleToAdd}>
            {#each articles as article}
            <option value={article.id}>{article.name}</option>
            {/each}
        </select>
        <input type="number" placeholder="Price" bind:value={price}>
        <button class="add-new-price" on:click={()=>{
            addNewPrice(client, articleToAdd, price)
            }}>+</button>
    </div>
</li>

<style>
    li{
        list-style: none;
        margin: 0 auto;
        padding: 40px;
        border: 1px solid #ccc;
        border-radius: 8px;
        background-color: #ddd;
        width: 80%;
    }
    input{
        width: 150px;
        height: 30px;
        border-radius: 5px;
    }
    div{
        display: flex;
        flex-direction: row;
        justify-content: left;
        gap: 25px;
    }
    ul{
        display: grid;
        grid-template-columns: 1fr;
        padding: 0;
        width: 100%;
        justify-content: center;
        align-items: center;
        max-width: 1200px;
        margin: 30px auto;
        display: grid;
        gap: 0.5rem;
    }
    p{
        margin: 4px;
        margin-bottom: 10px;
        padding: 0px;
        width: 200px;
        text-align: left;
    }
    .h{
        margin-bottom: 10px;
        padding: 5px 0px;
        font-size: 24px;
        border-bottom: 1px solid #bbb;
    }
    .remove{
        background-color: darkred;
        color: white;
        border-radius: 0px 5px 5px 0px;
        width: 50px;
        height: 50px;
        font-size: small;
        right: 0px;
        margin: 0;
        padding: 0;
    }
    .remove:hover{
        background-color: red;
    }
    .add-new-price{
        width: 30px;
        height: 30px;
        border-radius: 5px;
        color: green;
        background-color: white;
        font-weight: 900;
    }
    .table-container{
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        background-color: white;
        border-radius: 5px;
        align-items: baseline;
        margin-bottom: 10px;
    }
    select{
        font-family: Inter, Avenir, Helvetica, Arial, sans-serif;
        font-size: 16px;
        line-height: 24px;
        font-weight: 400;   
        width: 250px;
        height: 50px;
        border: none;
        border-radius: 5px;
        padding-left: 20px;
    }
    @media (min-width: 1000px) {
        ul { grid-template-columns: repeat(2, 1fr); }
    }
</style>