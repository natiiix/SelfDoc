using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Linq;

namespace SelfDoc
{
    public class Program
    {
        private static Dictionary<string, double> variables = new Dictionary<string, double>();

        private static void Main(string[] args)
        {
            string command = string.Empty;

            while (!string.IsNullOrWhiteSpace(command = Prompt()))
            {
                Match match = null;

                if ((match = Regex.Match(command, @"^let\s+(\w+)\s+be\s+(.+)$")).Success)
                {
                    variables[match.Groups[1].Value] = Evaluate(match.Groups[2].Value);
                }
                else if ((match = Regex.Match(command, @"^print\s+(.+)$")).Success)
                {
                    Console.WriteLine(string.Join("; ", SplitArgs(match.Groups[1].Value).Select(x => $"{x} = {Evaluate(x)}")));
                }
            }
        }

        private static double Evaluate(string str)
        {
            Match match = null;

            if (str.StartsWith('-'))
            {
                return -Evaluate(str.Substring(1));
            }
            else if (variables.ContainsKey(str))
            {
                return variables[str];
            }
            else if (double.TryParse(str, out double value))
            {
                return value;
            }
            else if ((match = Regex.Match(str, @"^sum\s+of\s+(.+)$")).Success)
            {
                return SplitArgs(match.Groups[1].Value).Select(x => Evaluate(x)).Sum();
            }
            else if ((match = Regex.Match(str, @"^product\s+of\s+(.+)$")).Success)
            {
                return SplitArgs(match.Groups[1].Value).Select(x => Evaluate(x)).Product();
            }
            else if ((match = Regex.Match(str, @"^(.+?)\s+plus\s+(.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) + Evaluate(match.Groups[2].Value);
            }
            else if ((match = Regex.Match(str, @"^(.+?)\s+minus\s+(.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) - Evaluate(match.Groups[2].Value);
            }
            else if ((match = Regex.Match(str, @"^(.+?)\s+times\s+(.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) * Evaluate(match.Groups[2].Value);
            }
            else if ((match = Regex.Match(str, @"^(.+?)\s+over\s+(.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) / Evaluate(match.Groups[2].Value);
            }

            throw new ArgumentException("Unable to evaluate: " + str);
        }

        private static string Prompt()
        {
            Console.Write("> ");
            return Console.ReadLine();
        }

        private static string[] SplitArgs(string str) =>
            Regex.Split(str, @"\s*\band\b\s*|\s*;\s*");
    }
}
