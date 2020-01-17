import CXShim
import CXTestUtility
import Nimble
import Quick

class VersioningDelaySpec: QuickSpec {

    override func spec() {
        
        afterEach {
            TestResources.release()
        }
        
        // FIXME: Versioning: out of sync
        xit("should not schedule subscription since iOS 13.3") {
            let subject = PassthroughSubject<Int, Never>()
            let scheduler = TestDispatchQueueScheduler.serial()
            let pub = subject.delay(for: .seconds(1), scheduler: scheduler)
            let sub = TestSubscriber<Int, Never>(receiveSubscription: { s in
                expect(scheduler.isCurrent).toVersioning([
                    .v11_0: beTrue(),
                    .v11_3: beFalse(),
                ])
            })
            pub.subscribe(sub)
            
            expect(sub.subscription).toVersioning([
                .v11_0: beNil(),
                .v11_3: beNotNil(),
            ])
            expect(sub.subscription).toEventuallyNot(beNil())
        }
    }
}
