<script>
    import OrderRow from "./OrderRow.svelte";
    import AddOrderRow from "./AddAOrderRow.svelte";
    import ClientInput from "./ClientInputField.svelte";
    import DateInput from "./DateInput.svelte";

    let orderRows = [];
    let clients = [];
    let articles = [];

    
    //get list of clients from localstorage
    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("client")){
            let client = JSON.parse(localStorage.getItem(key));
            clients.push(client);
        }
    }

    //get list of articles from localstorage
    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("article")){
            let article = JSON.parse(localStorage.getItem(key));
            articles.push(article);
        }
    }

    //function that generates a random id not used by any other orderRow
    function generateId() {
        let id = Math.floor(Math.random() * 100000);
        while (orderRows.find((orderRow) => orderRow.id === id)) {
            id = Math.floor(Math.random() * 100000);
            if(orderRows.length === 100000){
                throw new Error("No more ids available");
            }
        }
        return id;
    }

    orderRows = [{ id: generateId(), article: "", amount: 0, price: 0} ];


    function addNewOrderRow(){
        let newOrderRow = {
            id: generateId(),
            article: "",
            amount: 0,
            price: 0
        };
        orderRows = [...orderRows, newOrderRow]
    }

    function handleClick(){
        addNewOrderRow()
    }

    //run addNewOrderRow when key enter is pressed
    function handleKeyDown(event){
        if(event.key === "Enter"){
            addNewOrderRow()
        }
    }

    //eventlistener for keydown
    window.addEventListener("keydown", handleKeyDown);

    function removeOrderRow(id){
        orderRows = orderRows.filter((orderRow) => orderRow.id !== id);
    }

    function handleInput(event, id){
        let newArticle;
        if (event.target.classList.contains("amo")){
            let newAmount = event.target.value;
            orderRows = orderRows.map((orderRow) => {
                if(orderRow.id === id){
                    return {
                        ...orderRow,
                        amount: newAmount
                    }
                }
                return orderRow;
            })
        }
        else{
            if(event.target.classList.contains("art")){
                newArticle = event.target.value;
            }
            else if(event.target.classList.contains("autocomplete-items")){
                newArticle = event.target.innerText;
                event.target.parentElement.parentElement.children[0].value = newArticle;
            }else{
                newArticle = event.target.parentElement.innerText;
                event.target.parentElement.parentElement.parentElement.children[0].value = newArticle;
            }
            orderRows = orderRows.map((orderRow) => {
                if(orderRow.id === id){
                    let client = clients.find((client) => client.id.toString() + " " + client.name.toLowerCase() === clientID.toLowerCase());
                    if(client){
                        let price = client.prices.find((price) => price.article.id.toString() + " " + price.article.name.toLowerCase() === newArticle.toLowerCase());
                        if(price){
                            console.log(price.price);
                            return {
                                ...orderRow,
                                article: newArticle,
                                price: price.price
                            }
                        }
                    }
                    let price = articles.find((article) => article.id.toString() + " " + article.name.toLowerCase() === newArticle.toLowerCase());
                    if(price && price.price){
                        return {
                            ...orderRow,
                            article: newArticle,
                            price: price.price
                        }
                    }
                    return{
                        ...orderRow,
                        article: newArticle,
                        price: 0
                    }
                }
                return orderRow;
            })
        }
    }

    

    function handleRowClick(e, id){
        if(e.target.classList.contains("remove")){
            removeOrderRow(id);
        }
        else{
            //update prices when clientID is changed
            handleInput(e, id);
        }
    }

    let clientID = "";

    function saveOrder(){
        let client = clients.find((client) => client.id.toString() + " " + client.name.toLowerCase() === clientID.toLocaleLowerCase());
        if(!client){
            alert("Please select a client");
            return;
        }
        //change the articles on the orderRows to the article objects
        let orderRowsToSave = [];
        orderRowsToSave = orderRows.map((orderRow, i) => {
            let article = articles.find((article) => article.id.toString() + " " + article.name.toLowerCase() === orderRow.article.toLowerCase());
            if(!article){
                alert("Order row " + (i + 1) + " is missing an article");
                orderRow.article = "";
                return;
            }else{
                return {
                    ...orderRow,
                    article: article
                }
            }
        })
        //check if all orderRows have an article
        let allOrderRowsHaveArticle = orderRows.every((orderRow) => orderRow.article !== "");
        if(!allOrderRowsHaveArticle){
            return [...orderRows];
        }
        //create a object to store the order
        let order = {
            id: generateId().toString(),
            time: new Date(),
            deliveryDate: startDate,
            orderRows: [...orderRowsToSave]
        }
        //save order to client.orders in localstorage
        client.orders = [...client.orders, order];
        localStorage.setItem("client" + client.id, JSON.stringify(client));
        for(let i = orderRows.length; orderRows.length = 0; i++){ 
            removeOrderRow(orderRows[i].id)
        }
        addNewOrderRow()
        clientID = ""
        console.log(order);
    }

    export function iso(date) {
      const pad = n => n < 10 ? "0" + n : n;
      return date.getFullYear() + "-" + pad(date.getMonth()+1) + "-" + pad(date.getDate());
    }

    let startDate = iso(new Date());
  
    const locale = {
        en: {
        days: "Mo|Tu|We|Th|Fr|Sa|Su".split("|"),
        months: "Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec".split('|'),
        start: 1,
        },
    }
    
    let culture = "en";

    let showDate = false

</script>

<h1>Ordervy</h1>
<div>

    <ClientInput bind:inputValueClient={clientID} on:click={()=>{handleRowClick(event,0)}}/>
        
    <div class="rows">
        <input type="text" id="delivery-date" on:focus={()=>{showDate = true}} placeholder="Delivery date" bind:value={startDate}/>
        {#if showDate}
        <DateInput bind:value={startDate} on:click={()=>{showDate = false}} {...locale[culture]}/>
            {/if}
    </div>


</div>
      
<ul>
    {#each orderRows as orderRow(orderRow.id)}
    <li>
        <OrderRow on:input={()=>{handleInput(event, orderRow.id)}} on:click={()=>{handleRowClick(event, orderRow.id)}}/>
        <div class="price"><p>{orderRow.price} kr/st</p></div>
    </li>    
    {:else}
    <p>Press the + button below to add a new order row.</p>
    {/each}
    <AddOrderRow on:click={handleClick}/>
</ul>
<div>
    <button on:click={()=>{
        for(let i = orderRows.length; orderRows.length = 0; i++){ 
                removeOrderRow(orderRows[i].id)
            }
            addNewOrderRow()
            clientID = ""
        }}>Radera order</button>
    <button on:click={saveOrder}>Spara order</button>
</div>

 <style>
    .price{
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        border-radius: 5px;
        margin-left: 70px;
        background-color: #bbb;
        padding: 0px;
        width: 100px;
        height: 30px;
        border: #aaa 1px solid;
    }
    .rows{
        position: relative;
        z-index: 1;
        display: flex;
        flex-direction: column;
        margin: 0;
        gap: 0;
    }
    input {
        border: 1px solid transparent;
        background-color: #f1f1f1;
        padding: 10px;
        font-size: 16px;
        width: 210px;
        height: 22px;
    }
    div{
        display: flex;
        flex-direction: row;
        justify-content: center;
        gap: 30px;
    }
    li{
        display: flex;
        flex-direction: row;
        list-style: none;
        align-items: baseline;
        justify-content: center;
    }

    ul{
        border-top: solid #ccc;
        border-bottom: solid #ccc;
        margin: 20px 80px;
        padding: 20px
    }
 </style>