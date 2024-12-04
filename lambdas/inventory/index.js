exports.handler = async (event) => {
    console.log("Inventory Lambda triggered!")
    console.log(event)
    return event
}