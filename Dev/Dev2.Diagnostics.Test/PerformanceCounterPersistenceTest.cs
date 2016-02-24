﻿// 
// /*
// *  Warewolf - The Easy Service Bus
// *  Copyright 2016 by Warewolf Ltd <alpha@warewolf.io>
// *  Licensed under GNU Affero General Public License 3.0 or later. 
// *  Some rights reserved.
// *  Visit our website for more information <http://warewolf.io/>
// *  AUTHORS <http://warewolf.io/authors.php> , CONTRIBUTORS <http://warewolf.io/contributors.php>
// *  @license GNU Affero General Public License <http://www.gnu.org/licenses/agpl-3.0.html>
// */

using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Dev2.Common.Interfaces.Monitoring;
using Dev2.Common.Interfaces.Wrappers;
using Dev2.Common.Wrappers;
using Dev2.Communication;
using Dev2.PerformanceCounters;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
// ReSharper disable InconsistentNaming

namespace Dev2.Diagnostics.Test
{
    public class TestCounter : IPerformanceCounter {
        #region Implementation of IPerformanceCounter

        public TestCounter()
        {
            Category = "";
            Name = "bob";
            PerfCounterType = WarewolfPerfCounterType.AverageExecutionTime;
        }

        public void Increment()
        {
        }

        public void IncrementBy(long ticks)
        {
        }

        public void Decrement()
        {
        }

        public string Category { get; private set; }
        public string Name { get; private set; }
        public WarewolfPerfCounterType PerfCounterType { get; private set; }

        public IList<CounterCreationData> CreationData()
        {
            return null;
        }

        public bool IsActive { get; set; }

        #endregion
    }

    [TestClass]
    public class PerformanceCounterPersistenceTest
    {

        [TestMethod]
        [Owner("Leon Rajindrapersadh")]
        [TestCategory("PerformanceCounterPersistence_Load")]
        public void CtorTest()
        {
            PerformanceCounterPersistence obj = new PerformanceCounterPersistence( new Mock<IFile>().Object);
            Assert.IsNotNull(obj);
        }
        [TestMethod]
        [Owner("Leon Rajindrapersadh")]
        [TestCategory("PerformanceCounterPersistence_Load")]
        public void PerformanceCounterPersistence_SaveEmpty_ExpectCountersSaved()
        {
        
            PerformanceCounterPersistence obj = new PerformanceCounterPersistence( new FileWrapper());

            IList<IPerformanceCounter> counters = new List<IPerformanceCounter>();
            var fileName = Path.GetTempFileName();
            obj.Save(counters, fileName);
            var saved =  File.ReadAllText(fileName);
            Dev2JsonSerializer  serialiser = new Dev2JsonSerializer();
            var persisted = serialiser.Deserialize<IList<IPerformanceCounter>>(saved);
            Assert.IsNotNull(persisted);
        }


        [TestMethod]
        [Owner("Leon Rajindrapersadh")]
        [TestCategory("PerformanceCounterPersistence_Load")]
        public void PerformanceCounterPersistence_Save_ExpectCountersSaved()
        {

            PerformanceCounterPersistence obj = new PerformanceCounterPersistence( new FileWrapper());
            IList<IPerformanceCounter> counters = new List<IPerformanceCounter>();
            counters.Add(new TestCounter());
            var fileName = Path.GetTempFileName();
            obj.Save(counters, fileName);
            var saved = File.ReadAllText(fileName);
            Dev2JsonSerializer serialiser = new Dev2JsonSerializer();
            var persisted = serialiser.Deserialize<IList<IPerformanceCounter>>(saved);
            Assert.AreEqual(persisted.Count,1);
            Assert.IsTrue(persisted.First() is TestCounter);
        }





        [TestMethod]
        [Owner("Leon Rajindrapersadh")]
        [TestCategory("PerformanceCounterPersistence_Load")]
        public void PerformanceCounterPersistence_Load_ExpectCountersLoadedForExistingFile()
        {
            var _file = new Mock<IFile>();
            PerformanceCounterPersistence obj = new PerformanceCounterPersistence( _file.Object);

            IList<IPerformanceCounter> counters = new List<IPerformanceCounter>();
            counters.Add(new TestCounter());
            var fileName = Path.GetTempFileName();
            _file.Setup(a => a.Exists(fileName)).Returns(true);
            obj.Save(counters, fileName);

            Dev2JsonSerializer serialiser = new Dev2JsonSerializer();
            File.WriteAllText(fileName,serialiser.Serialize(counters));
            _file.Setup(a => a.ReadAllText(fileName)).Returns(File.ReadAllText(fileName));
            var persisted = obj.LoadOrCreate(fileName);
            Assert.AreEqual(persisted.Count, 1);
            Assert.IsTrue(persisted.First() is TestCounter);
        }


        [TestMethod]
        [Owner("Leon Rajindrapersadh")]
        [TestCategory("PerformanceCounterPersistence_Load")]
        public void PerformanceCounterPersistence_Load_ExpectCountersRecreatedForNoFile()
        {
            var _file = new Mock<IFile>();
            var register = new Mock<IWarewolfPerformanceCounterRegister>();

            PerformanceCounterPersistence obj = new PerformanceCounterPersistence( _file.Object);

            IList<IPerformanceCounter> counters = new List<IPerformanceCounter>();
            counters.Add(new TestCounter());
            register.Setup(a => a.DefaultCounters).Returns(counters);
            var fileName = Path.GetTempFileName();
            _file.Setup(a => a.Exists(fileName)).Returns(false);
            obj.Save(counters, fileName);
            var persisted = obj.LoadOrCreate(fileName);
            Assert.AreEqual(persisted.Count, 1);
            Assert.IsTrue(persisted.First() is TestCounter);
        }

    }
}