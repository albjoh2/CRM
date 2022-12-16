<script>
    let clients = [];

    //get clients from localstorage

    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("client")){
            let client = JSON.parse(localStorage.getItem(key));
            clients.push(client);
        }
    }


    function removeOrderFromLocalStorage(client, id){
        client.orders = client.orders.filter((order) => order.id !== id);
        localStorage.setItem("client" + client.id, JSON.stringify(client));
        clients = [...clients];
    }


</script>

<h1>Order List</h1>
<ul>
    <div>
        <p>Order number: </p>
        <p>Client: </p>
        <p>Order date: </p>
        <p>Delivery date: </p>
    </div>
    {#each clients as client}
    {#each client.orders as order}
    <li>
        <div class="order-head">
            <p>{order.id}</p>
            <p>{client.id} {client.name}</p>
            <p>{order.time.slice(0,10)}</p>
            <p>{order.deliveryDate}</p>
            <button class="delete-button" on:click={()=>{removeOrderFromLocalStorage(client, order.id)}}>x</button>
        </div>
        <table>
            <thead>
                <th class="article">Article</th>
                <th>Amount</th>
                <th>Price</th>
            </thead>
            {#each order.orderRows as orderRow}
            <tbody>
                <td class="article">{orderRow.article.id} {orderRow.article.name}</td>
                <td>{orderRow.amount} st</td>
                <td>{orderRow.price} kr/st</td>
            </tbody>
            {/each}
            
        </table>
    </li>

    {/each}
    {:else}
    <p class="no-orders">Press the + button below to create a new order.</p>
    {/each}
    <a href="orderview"><button href={"orderview"}>+</button></a>
</ul>

<style>
    div{
        display: flex;
        flex-direction: row;
        justify-content: left;
        align-items: center;
        margin: 0px;
        width: 500px;
    }
    ul{
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        padding: 0px; 
        margin: 50px 100px;
    }
    li{
        display: flex;
        flex-direction: column;
        align-items: baseline;
        justify-content: baseline;
        list-style: none;
        background-color: white;
        padding: 0px;
        border-radius: 10px;
        height: 50px;
        width: 500px;
        position: relative;
        transition: height 0.5s;
        -webkit-transition: height 0.5s;
        overflow: hidden;
        margin-bottom: 5px;
    }

    li:hover {
        height: fit-content;
    }
    .order-head{
        display: flex;
        flex-direction: row;
        justify-content: left;
        align-items: baseline;
        margin: 0px;
        background-color: darkgray;
        color:white;
        width: 100%;
        margin: 0px;
        padding: 0px;
        border-radius: 10px 10px 0px 0px;
        font-size: small;
        font-weight: 900;
        
    }
    table{
        border-collapse: collapse;
        width: 100%;
        margin: 0px;
        padding: 200px 0px;
    }

    td{
        border: 1px solid #eeeeee;
        padding: 5px 20px;
        margin: 0;
    }
    .article{
        text-align: left;
    }
    th{
        border: 1px solid #eeeeee;
        border-bottom: 1px solid #aaaaaa;
        padding: 10px 20px;
        margin: 0;
    }
    .delete-button{
        position: absolute;
        background-color: darkred;
        color: white;
        border: none;
        border-radius: 0px 10px 0px 0px;
        width: 50px;
        height: 50px;
        font-size: small;
        right: 0px;
        margin: 0;
    }
    .delete-button:hover{
        background-color: red;
        border-radius: 0px 10px 0px 0px;
    }
    p{
        width: 107px;
    }
    .no-orders{
        width: 100%;
        margin-top: 30px;
        padding: 0px;
        font-size: large;
    }
    button{
        color: green;
        font-size: 20px;
        font-weight: 900;
        display: inline-block;
    }

    button:hover{
        cursor: pointer;
    }
</style>