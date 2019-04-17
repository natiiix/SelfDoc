using System.Collections.Generic;

namespace SelfDoc
{
    internal static class ExtensionMethods
    {
        internal static double Product(this IEnumerable<double> values)
        {
            double product = 1.0;

            foreach (double v in values)
            {
                product *= v;
            }

            return product;
        }
    }
}
