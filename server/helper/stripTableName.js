module.exports = ( data, variableName ) => {
    var str = JSON.stringify(data);
    var regEx = new RegExp(`"[A-Za-z?_]+\.${variableName}`, 'g');
    str = str.replace(regEx, `"${variableName}`);
    str = str.replace(/"[A-Za-z?_]+\.id/g, '"id');
    // console.log(str);
    return JSON.parse(str);
    // data = data.replace(/.+\.name/g, 'name');
    // data = data.replace(/.+\.country/g, 'country');
    // data = data.replace(/.+\.region_name/g, 'region_name');
    // data = data.replace(/.+\.address/g, 'address');
};
