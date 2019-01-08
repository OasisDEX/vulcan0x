import { makeBatches } from "./sync";

describe("make batches", () => {
  it("should work", () => {
    const batches = makeBatches(10, 15, 2);

    expect(batches).toEqual([{ from: 10, to: 12 }, { from: 12, to: 14 }, { from: 14, to: 15 }]);
  });
});
