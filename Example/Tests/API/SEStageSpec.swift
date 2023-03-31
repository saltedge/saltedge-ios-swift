//
//  SEStageSpec.swift
//
//  Copyright (c) 2023 Salt Edge. https://saltedge.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Quick
import Nimble
@testable import SaltEdge

class SEStageSpec: QuickSpec {
    override func spec() {
        describe("SEStage") {
            var stage: SEStage!

            beforeEach {
                let json = """
                {
                    "created_at": "2022-03-30T15:00:00Z",
                    "id": "stage_id",
                    "interactive_fields_names": ["name", "email"],
                    "interactive_fields_options": {
                        "name": ["Alice", "Bob", "Charlie"],
                        "email": ["alice@example.com", "bob@example.com", "charlie@example.com"]
                    },
                    "interactive_html": "<form><label>Name: <input type='text' name='name'></label><br><label>Email: <input type='email' name='email'></label></form>",
                    "name": "Signup",
                    "updated_at": "2022-03-30T15:30:00Z"
                }
                """.data(using: .utf8)!
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                stage = try! decoder.decode(SEStage.self, from: json)
            }

            it("can be decoded from JSON") {
                expect(stage.id).to(equal("stage_id"))
                expect(stage.interactiveFieldsNames).to(equal(["name", "email"]))
                expect(stage.interactiveFieldsOptions?["name"] as? [String]).to(equal(["Alice", "Bob", "Charlie"]))
                expect(stage.interactiveFieldsOptions?["email"] as? [String]).to(equal(["alice@example.com", "bob@example.com", "charlie@example.com"]))
                expect(stage.interactiveHtml) == "<form><label>Name: <input type='text' name='name'></label><br><label>Email: <input type='email' name='email'></label></form>"
                expect(stage.name).to(equal("Signup"))
            }

            it("has correct CodingKeys") {
                expect(SEStage.CodingKeys.createdAt.rawValue).to(equal("created_at"))
                expect(SEStage.CodingKeys.id.rawValue).to(equal("id"))
                expect(SEStage.CodingKeys.interactiveFieldsNames.rawValue).to(equal("interactive_fields_names"))
                expect(SEStage.CodingKeys.interactiveFieldsOptions.rawValue).to(equal("interactive_fields_options"))
                expect(SEStage.CodingKeys.interactiveHtml.rawValue).to(equal("interactive_html"))
                expect(SEStage.CodingKeys.name.rawValue).to(equal("name"))
                expect(SEStage.CodingKeys.updatedAt.rawValue).to(equal("updated_at"))
            }
        }
    }
}
