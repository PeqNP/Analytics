import AutoEquatable
import Quick
import Nimble
import Spry
import Spry_Nimble

@testable import Analytics

enum FakeEvent: AnalyticsEvent, AutoEquatable, SpryEquatable {
    case foo
    case bar(name: String)
}

class AnalyticsServiceSpec: QuickSpec {
    override func spec() {
        
        describe("AnalyticsService") {
            var subject: AnalyticsService!
            var fakeListener0: FakeAnalyticsListener!
            var fakeListener1: FakeAnalyticsListener!
            
            beforeEach {
                fakeListener0 = FakeAnalyticsListener()
                fakeListener1 = FakeAnalyticsListener()
                subject = AnalyticsService(listeners: [fakeListener0, fakeListener1])
            }
            
            describe("send an event") {
                beforeEach {
                    fakeListener0.stub(.receive).andReturn()
                    fakeListener1.stub(.receive).andReturn()
                    
                    subject.send(FakeEvent.foo)
                }
                
                it("should have sent an event to both listeners") {
                    expect(fakeListener0).to(haveReceived(.receive, with: FakeEvent.foo))
                    expect(fakeListener1).to(haveReceived(.receive, with: FakeEvent.foo))
                }
            }
            
            describe("publisher; sending an event") {
                var publisher: AnalyticsPublisher<FakeEvent>!
                
                beforeEach {
                    fakeListener0.stub(.receive).andReturn()
                    fakeListener1.stub(.receive).andReturn()

                    publisher = subject.publisher()
                    publisher.send(.bar(name: "name"))
                }
                
                it("should have sent an event to both listeners") {
                    expect(fakeListener0).to(haveReceived(.receive, with: FakeEvent.bar(name: "name")))
                    expect(fakeListener1).to(haveReceived(.receive, with: FakeEvent.bar(name: "name")))
                }
            }
        }
        
    }
}
