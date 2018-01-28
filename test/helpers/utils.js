module.exports = {
    zeroAddress: '0x0000000000000000000000000000000000000000',
    exceptionGasToUse: 3000000,
    isException: isException,
    ensureException: ensureException
};

function isException(error) {
    let strError = error.toString();
    return strError.includes('invalid opcode') || strError.includes('invalid JUMP') || strError.includes('out of gas') || strError.includes('VM Exception');
}

function ensureException(error) {
    assert(isException(error), error.toString());
}