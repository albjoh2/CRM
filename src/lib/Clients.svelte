<script>
    //make list of clients
    let clients = [];
    let name = "";

    //get all clients from localstorage and add them to clients
    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("client")){
            let client = JSON.parse(localStorage.getItem(key));
            clients.push(client);
        }
        console.log(clients)
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

    //create a function to add a new client
    function addNewClient(name){
        let clientname = name;
        let clientID = generateId();
        let newClient = ({
            id: clientID,
            name: clientname,
            address: "",
            zip: "",
            city: "",
            phone: "",
            email: "",
            contact: "",
            contactPhone: "",
            contactEmail: "",
            comment: "",
            orders: [],
            prices: []
        })
        //Add new client to localstorage
        localStorage.setItem("client" + newClient.id, JSON.stringify(newClient));
        //Add new client to clients
        clients = [...clients, newClient];
    }

    //remove client from local storage
    function removeClientFromLocalStorage(id){
        localStorage.removeItem("client" + id);
        clients = clients.filter((client) => client.id !== id);
    }


</script>
<h1>Clients</h1>
<ul>
    <div>
        <p>Client id</p>
        <p>Client name</p>
    </div>
    {#each clients as client}
    <li>
        <div>
            <p>{client.id}</p>
            <p>{client.name}</p>
            <button class="delete-button" on:click={()=>{removeClientFromLocalStorage(client.id)}}>x</button>
        </div>
    </li>
    {:else}
    <p class="no-clients">Press the + button below to add a new client.</p>
    {/each}
    <div>
        <input type="text" placeholder="Client name" bind:value={name}>
        <button on:click={()=>{
            addNewClient(name) 
            name = ""
        }}>+</button>
    </div>
</ul>

<style>
    input{
        width: 100%;
        padding: 12px 20px;
        margin: 8px 0;
        box-sizing: border-box;
    }
    .no-clients{
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
        padding: 0px; 
        margin: 50px 100px;
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
        width: 150px;
        height: 20px;
        padding: 0;
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